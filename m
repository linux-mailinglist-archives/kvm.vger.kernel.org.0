Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4ED0539FE2
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350939AbiFAIyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350940AbiFAIy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:54:28 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792F365406;
        Wed,  1 Jun 2022 01:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1654073667; x=1685609667;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=eajaxf7iBpp2vMrvyiSKrSeUPTOtK30onKdBAX1DOds=;
  b=ofcZMYVrje0HBFvDkl37QIB3JzaAezrC/VPCFTvPzHlCA418i9UjGaY3
   j6QmpckXXVQREshXnJ2CT0OW6cAVggmqjzXjtdQr8afMuqxBdEKSYVe/K
   j2P0JRhg2CgLTH4Rib9hWojh1jIdF7pgsT+X5dDjdpGlEsBvk02oSPk2S
   Q=;
X-IronPort-AV: E=Sophos;i="5.91,266,1647302400"; 
   d="scan'208";a="93761336"
Subject: RE: ...\n
Thread-Topic: ...\n
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 01 Jun 2022 08:54:11 +0000
Received: from EX13D33EUC004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id CE82042870;
        Wed,  1 Jun 2022 08:54:10 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D33EUC004.ant.amazon.com (10.43.164.63) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 1 Jun 2022 08:54:09 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.036;
 Wed, 1 Jun 2022 08:54:09 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "Allister, Jack" <jalliste@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "diapop@amazon.co.uk" <diapop@amazon.co.uk>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "metikaya@amazon.co.uk" <metikaya@amazon.co.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
Thread-Index: AQHYdPhkNX+wk5QumkS6hY2ybmOpva05D+WAgAABcbCAAQ0lgIAAE6AAgAALn5A=
Date:   Wed, 1 Jun 2022 08:54:08 +0000
Message-ID: <48edf12807254a2b86e339b26873bf00@EX13D32EUC003.ant.amazon.com>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
 <YpcMw2TgNWzrcoRm@worktop.programming.kicks-ass.net>
 <87r148olol.fsf@redhat.com>
In-Reply-To: <87r148olol.fsf@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.66]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-12.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
[snip]
> >>
> >> I'll bite... What's ludicrous about wanting to run a guest at a lower
> >> CPU freq to minimize observable change in whatever workload it is
> >> running?
> >
> > *why* would you want to do that? Everybody wants their stuff done
> > faster.
> >
>=20
> FWIW, I can see a valid use-case: imagine you're running some software
> which calibrates itself in the beginning to run at some desired real
> time speed but then the VM running it has to be migrated to a host with
> faster (newer) CPUs. I don't have a real world examples out of top of my
> head but I remember some old DOS era games were impossible to play on
> newer CPUs because everything was happenning too fast. Maybe that's the
> case :-)
>=20

That is exactly the case. This is not 'some hare-brained money scheme'; the=
re is genuine concern that moving a VM from old h/w to new h/w may cause it=
 to run 'too fast', breaking any such calibration done by the guest OS/appl=
ication. I also don't have any real-world examples, but bugs may well be re=
ported and having a lever to address them is IMO a good idea.
However, I also agree with Paolo that KVM doesn't really need to be doing t=
his when the VMM could do the job using cpufreq, so we'll pursue that optio=
n instead. (FWIW the reason for involving KVM was to do the freq adjustment=
 right before entering the guest and then remove the cap right after VMEXIT=
).

  Paul
