Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D511213983
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 13:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgGCLlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 07:41:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24128 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726112AbgGCLll (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 07:41:41 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063BUv1Y000696;
        Fri, 3 Jul 2020 07:40:46 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 320wmq5k82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 07:40:46 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 063BWGpg004464;
        Fri, 3 Jul 2020 07:40:45 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 320wmq5k77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 07:40:45 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063BaVop023875;
        Fri, 3 Jul 2020 11:40:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 31wwch6rqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 11:40:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063BefcM63570196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 11:40:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E3B9A405B;
        Fri,  3 Jul 2020 11:40:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FCE2A405C;
        Fri,  3 Jul 2020 11:40:39 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.204.195])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 Jul 2020 11:40:39 +0000 (GMT)
Date:   Fri, 3 Jul 2020 14:40:37 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Abhishek Bhardwaj <abhishekbh@google.com>
Cc:     Anthony Steinhauser <asteinhauser@google.com>,
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
        x86 <x86@kernel.org>, Doug Anderson <dianders@google.com>
Subject: Re: [PATCH v3] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
Message-ID: <20200703114037.GD2999146@linux.ibm.com>
References: <20200702221237.2517080-1-abhishekbh@google.com>
 <e7bc00fc-fe53-800e-8439-f1fbdca5dd26@redhat.com>
 <CAN_oZf2t+gUqXe19Yo1mTzAgk2xNhssE-9p58EvH-gw5jpuvzA@mail.gmail.com>
 <CA+noqoj6u9n_KKohZw+QCpD-Qj0EgoCXaPEsryD7ABZ7QpqQfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+noqoj6u9n_KKohZw+QCpD-Qj0EgoCXaPEsryD7ABZ7QpqQfg@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_03:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 adultscore=0 cotscore=-2147483648 suspectscore=1
 phishscore=0 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 02, 2020 at 11:43:47PM -0700, Abhishek Bhardwaj wrote:
> We have tried to steer away from kernel command line args for a few reasons.
> 
> I am paraphrasing my colleague Doug's argument here (CC'ed him as well) -
> 
> - The command line args are getting unwieldy. Kernel command line
> parameters are not a scalable way to set kernel config. It's intended
> as a super limited way for the bootloader to pass info to the kernel
> and also as a way for end users who are not compiling the kernel
> themselves to tweak kernel behavior.

Why cannot you simply add this option to CONFIG_CMDLINE at your kernel build
scripts?
 
> - Also, we know we want this setting from the start. This is a
> definite smell that it deserves to be a compile time thing rather than
> adding extra code + whatever miniscule time at runtime to pass an
> extra arg.

This might be a compile time thing in your environment, but not
necessarily it must be the same in others. For instance, what option
should distro kernels select?

> I think this was what CONFIGS were intended for. I'm happy to add all
> this to the commit message once it's approved in spirit by the
> maintainers.
> 
> On Thu, Jul 2, 2020 at 8:18 PM Anthony Steinhauser
> <asteinhauser@google.com> wrote:
> >
> > Yes, this probably requires an explanation why the change is necessary
> > or useful. Without that it is difficult to give some meaningful
> > feedback.
> 
> 
> 
> -- 
> Abhishek

-- 
Sincerely yours,
Mike.
