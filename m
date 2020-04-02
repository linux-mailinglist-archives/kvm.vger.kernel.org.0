Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E46819CA65
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 21:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387726AbgDBTnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 15:43:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55818 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbgDBTnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 15:43:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032JdkjM137611;
        Thu, 2 Apr 2020 19:43:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/GFNmv7VQzb8FXtdHAPCT782Li+VvJuG5j6p4uNWYkg=;
 b=pABKxR6pRK8S7f+1V0CqUiBXPXEApT4H1Mvfr6cqvw0Cp407GYxY9hzK2SUYEd6u9IK4
 oP49AOvsIKmF7pyBDJeAWljJcwXJPC46RHQRGKLUEoarbdC1EBV35k3z3Arga3+JhnjZ
 8j2JTQ8iDnbgOed+QwwT9JkbrXoQN3YdwHgyMyAgOkiW7UVywpBhN+Fz5tADNmlSP1D5
 03Z5aJ2hNA38Xfnoe07la2UaWtrcUHFGpbUux2NLaLu7AdKISn4fAg72ICmN0LFYKx0E
 Mp8HRPMsCP7Iyfk7eBfVVajju2eHQUWv0HERbN8Cb6FwQN+rLqwSKAR3RzDyo/XhqJP4 SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 303cevdhcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 19:43:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032Jb69D018370;
        Thu, 2 Apr 2020 19:43:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 302g2k5sng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 19:43:20 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 032JhIaE014830;
        Thu, 2 Apr 2020 19:43:18 GMT
Received: from vbusired-dt (/10.154.166.66)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 12:43:18 -0700
Date:   Thu, 2 Apr 2020 14:43:13 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 01/14] KVM: SVM: Add KVM_SEV SEND_START command
Message-ID: <20200402194313.GA656773@vbusired-dt>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <3f90333959fd49bed184d45a761cc338424bf614.1585548051.git.ashish.kalra@amd.com>
 <20200402062726.GA647295@vbusired-dt>
 <89a586e4-8074-0d32-f384-a4597975d129@amd.com>
 <20200402163717.GA653926@vbusired-dt>
 <8b1b4874-11a8-1422-5ea1-ed665f41ab5c@amd.com>
 <20200402185706.GA655878@vbusired-dt>
 <6ced22f7-cbe5-a698-e650-7716566d4d8a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ced22f7-cbe5-a698-e650-7716566d4d8a@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-02 14:17:26 -0500, Brijesh Singh wrote:
> 
> On 4/2/20 1:57 PM, Venu Busireddy wrote:
> [snip]...
> 
> >> The question is, how does a userspace know the session length ? One
> >> method is you can precalculate a value based on your firmware version
> >> and have userspace pass that, or another approach is set
> >> params.session_len = 0 and query it from the FW. The FW spec allow to
> >> query the length, please see the spec. In the qemu patches I choose
> >> second approach. This is because session blob can change from one FW
> >> version to another and I tried to avoid calculating or hardcoding the
> >> length for a one version of the FW. You can certainly choose the first
> >> method. We want to ensure that kernel interface works on the both cases.
> > I like the fact that you have already implemented the functionality to
> > facilitate the user space to obtain the session length from the firmware
> > (by setting params.session_len to 0). However, I am trying to address
> > the case where the user space sets the params.session_len to a size
> > smaller than the size needed.
> >
> > Let me put it differently. Let us say that the session blob needs 128
> > bytes, but the user space sets params.session_len to 16. That results
> > in us allocating a buffer of 16 bytes, and set data->session_len to 16.
> >
> > What does the firmware do now?
> >
> > Does it copy 128 bytes into data->session_address, or, does it copy
> > 16 bytes?
> >
> > If it copies 128 bytes, we most certainly will end up with a kernel crash.
> >
> > If it copies 16 bytes, then what does it set in data->session_len? 16,
> > or 128? If 16, everything is good. If 128, we end up causing memory
> > access violation for the user space.
> 
> My interpretation of the spec is, if user provided length is smaller
> than the FW expected length then FW will reports an error with
> data->session_len set to the expected length. In other words, it should
> *not* copy anything into the session buffer in the event of failure.

That is good, and expected behavior.

> If FW is touching memory beyond what is specified in the session_len then
> its FW bug and we can't do much from kernel.

Agreed. But let us assume that the firmware is not touching memory that
it is not supposed to.

> Am I missing something ?

I believe you are agreeing that if the session blob needs 128 bytes and
user space sets params.session_len to 16, the firmware does not copy
any data to data->session_address, and sets data->session_len to 128.

Now, when we return, won't the user space try to access 128 bytes
(params.session_len) of data in params.session_uaddr, and crash? Because,
instead of returning an error that buffer is not large enough, we return
the call successfully!

That is why I was suggesting the following, which you seem to have
missed.

> > Perhaps, this can be dealt a little differently? Why not always call
> > sev_issue_cmd(kvm, SEV_CMD_SEND_START, ...) with zeroed out data? Then,
> > if the user space has set params.session_len to 0, we return with the
> > needed params.session_len. Otherwise, we check if params.session_len is
> > large enough, and if not, we return -EINVAL?

Doesn't the above approach address all scenarios?

