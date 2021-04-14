Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4AD35EBFA
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 06:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhDNEkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 00:40:43 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36764 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhDNEkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 00:40:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13E4U1FE039741;
        Wed, 14 Apr 2021 04:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Bd4/hg1yN1is4IRJn7hT6CyZTbFjK4SqbaFRqE8RBN8=;
 b=GDhlovi8GebAxK8lBABqyOkduyXZ8ROVjsZYsvvAarJBH9EElr42BK9NSjnbWDUkue9x
 ke0VO8SRzVPbjAXmqylIvdhhCAfJQvQXCscPoq9R7P+bSbDThL19ya2fTEWxudgzX5YN
 2MpT5FhVoZvxYjhTo2e6X7QDgu4rohNhW5a7IMQiTTCaARtprCiTSno9B1iojLaWN2tB
 QMt5cMNb8YnLLVanQxMTvu/fmkgR7bEbvZ/LvLqL4qDYlkcZq0OZ0gytoU07NsuWqJvv
 iJkyhSk34fw9oRHWn6u1FpVhLMI2RLWQk8uzFIrs7UPv12RQWut4ljw91gOFzb1WQhGy AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hbh5ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 04:38:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13E4ZVxl007477;
        Wed, 14 Apr 2021 04:38:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 37unstc5ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 04:38:30 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13E4cH43023157;
        Wed, 14 Apr 2021 04:38:21 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Apr 2021 04:38:17 +0000
Date:   Wed, 14 Apr 2021 07:37:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        syzbot <syzbot+015dd7cdbbbc2c180c65@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        daniel.vetter@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        James Morris <jmorris@namei.org>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        m.szyprowski@samsung.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [syzbot] WARNING in unsafe_follow_pfn
Message-ID: <20210414043759.GM6021@kadam>
References: <000000000000ca9a6005bec29ebe@google.com>
 <2db3c803-6a94-9345-261a-a2bb74370c02@redhat.com>
 <20210331042922.GE2065@kadam>
 <20210401121933.GA2710221@ziepe.ca>
 <CACT4Y+ZG9Dhv1UTvotsTimVrzaojPN91Lu1CsPqm4kd1j5yNkQ@mail.gmail.com>
 <20210413181145.GK227011@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413181145.GK227011@ziepe.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140030
X-Proofpoint-GUID: 5W5g74JUOBhBXqiypFmTmoVnXKL81tdF
X-Proofpoint-ORIG-GUID: 5W5g74JUOBhBXqiypFmTmoVnXKL81tdF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104140029
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 03:11:45PM -0300, Jason Gunthorpe wrote:
> On Tue, Apr 13, 2021 at 07:20:12PM +0200, Dmitry Vyukov wrote:
> > > > Plus users are going to be seeing this as well.  According to the commit
> > > > message for 69bacee7f9ad ("mm: Add unsafe_follow_pfn") "Unfortunately
> > > > there's some users where this is not fixable (like v4l userptr of iomem
> > > > mappings)".  It sort of seems crazy to dump this giant splat and then
> > > > tell users to ignore it forever because it can't be fixed...  0_0
> > >
> > > I think the discussion conclusion was that this interface should not
> > > be used by userspace anymore, it is obsolete by some new interface?
> > >
> > > It should be protected by some kconfig and the kconfig should be
> > > turned off for syzkaller runs.
> > 
> > If this is not a kernel bug, then it must not use WARN_ON[_ONCE]. It
> > makes the kernel untestable for both automated systems and humans:
> 
> It is a kernel security bug triggerable by userspace.
> 
> > And if it's a kernel bug reachable from user-space, then I think this
> > code should be removed entirely, not just on all testing systems. Or
> > otherwise if we are not removing it for some reason, then it needs to
> > be fixed.
> 
> Legacy embedded systems apparently require it.

Are legacy embedded systems ever going to update their kernel?  It might
be better to just remove it.  (I don't really have any details outside
of your email so I don't know).

regards,
dan carpenter

