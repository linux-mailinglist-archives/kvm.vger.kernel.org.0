Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7AB214DA0
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 17:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgGEPYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 11:24:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37210 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbgGEPYZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Jul 2020 11:24:25 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 065F7J3m146263;
        Sun, 5 Jul 2020 11:23:13 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3237cf9dqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Jul 2020 11:23:13 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 065F7hAY146985;
        Sun, 5 Jul 2020 11:23:12 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3237cf9dpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Jul 2020 11:23:12 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 065FJwsU022824;
        Sun, 5 Jul 2020 15:23:10 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 322hd7sc1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Jul 2020 15:23:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 065FN8eb39977132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 5 Jul 2020 15:23:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45971A405B;
        Sun,  5 Jul 2020 15:23:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 166A0A4054;
        Sun,  5 Jul 2020 15:23:06 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.205.69])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun,  5 Jul 2020 15:23:05 +0000 (GMT)
Date:   Sun, 5 Jul 2020 18:23:04 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Doug Anderson <dianders@google.com>
Cc:     Abhishek Bhardwaj <abhishekbh@google.com>,
        Anthony Steinhauser <asteinhauser@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86 <x86@kernel.org>
Subject: Re: [PATCH v3] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
Message-ID: <20200705152304.GE2999146@linux.ibm.com>
References: <20200702221237.2517080-1-abhishekbh@google.com>
 <e7bc00fc-fe53-800e-8439-f1fbdca5dd26@redhat.com>
 <CAN_oZf2t+gUqXe19Yo1mTzAgk2xNhssE-9p58EvH-gw5jpuvzA@mail.gmail.com>
 <CA+noqoj6u9n_KKohZw+QCpD-Qj0EgoCXaPEsryD7ABZ7QpqQfg@mail.gmail.com>
 <20200703114037.GD2999146@linux.ibm.com>
 <CAD=FV=XRbrFqSbR619h+9HXNyrYNbqfBF2e-+iUZco9qQ8Wokg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=XRbrFqSbR619h+9HXNyrYNbqfBF2e-+iUZco9qQ8Wokg@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-05_05:2020-07-02,2020-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=1 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 cotscore=-2147483648 malwarescore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007050116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 03, 2020 at 07:00:11AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Fri, Jul 3, 2020 at 4:40 AM Mike Rapoport <rppt@linux.ibm.com> wrote:
> >
> > On Thu, Jul 02, 2020 at 11:43:47PM -0700, Abhishek Bhardwaj wrote:
> > > We have tried to steer away from kernel command line args for a few reasons.
> > >
> > > I am paraphrasing my colleague Doug's argument here (CC'ed him as well) -
> > >
> > > - The command line args are getting unwieldy. Kernel command line
> > > parameters are not a scalable way to set kernel config. It's intended
> > > as a super limited way for the bootloader to pass info to the kernel
> > > and also as a way for end users who are not compiling the kernel
> > > themselves to tweak kernel behavior.
> >
> > Why cannot you simply add this option to CONFIG_CMDLINE at your kernel build
> > scripts?
> 
> At least in the past I've seen that 'CONFIG_CMDLINE' interacts badly
> with the bootloader provided command line in some architectures.  In
> days of yore I tried to post a patch to fix this, at least on ARM
> targets, but it never seemed to go anywhere upstream.  I'm going to
> assume this is still a problem because I still see an ANDROID tagged
> patch in the Chrome OS 5.4 tree:

I presume a patch subject should have been here :)
Anyway, bad iteraction of CONFIG_CMDLINE with bootloader command line
seems like a bug to me and a bug need to be fixed.

> In any case, as per my previous arguments, stuffing lots of config
> into the cmdline is a bit clunky and doesn't scale well.  You end up
> with a really long run on command line and it's hard to tell where one
> config option ends and the next one starts and if the same concept is
> there more than one time it's hard to tell and something might cancel
> out a previous config option or maybe it won't and by the time you end
> up finishing this it's hard to tell where you started.  :-)

Configuration options may also have weird interactions between them and
addition of #ifdef means that most of the non-default paths won't get as
good test coverage as the default one.

And the proposed #ifdef maze does not look pretty at all...

> > > - Also, we know we want this setting from the start. This is a
> > > definite smell that it deserves to be a compile time thing rather than
> > > adding extra code + whatever miniscule time at runtime to pass an
> > > extra arg.
> >
> > This might be a compile time thing in your environment, but not
> > necessarily it must be the same in others. For instance, what option
> > should distro kernels select?
> 
> Nothing prevents people from continuing to use the command line
> options if they want, right?  This just allows a different default.
> So if a distro is security focused and decided that it wanted a slower
> / more secure default then it could ship that way but individual users
> could still override, right?

Well, nothing prevents you from continuing to use the command line as
well ;-)

I can see why whould you want an ability to select compile time default
for an option, but I'm really not thrilled by the added ifdefery.
 
> > > I think this was what CONFIGS were intended for. I'm happy to add all
> > > this to the commit message once it's approved in spirit by the
> > > maintainers.
> > >

-- 
Sincerely yours,
Mike.
