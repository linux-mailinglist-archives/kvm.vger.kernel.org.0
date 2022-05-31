Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8AB539423
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 17:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345801AbiEaPjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 11:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345794AbiEaPjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 11:39:46 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF888BD1A;
        Tue, 31 May 2022 08:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1654011586; x=1685547586;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=CI6iH6yoecF9cc7BOEACEO1QsTfmPhaS1od4bXaY42o=;
  b=jmqV5VVhmobue6GPr6fJID30p/J1EhPhSWs1zmk7BdB2wfMFXI0jMR+9
   TmFe/AZAvJRCX9wov5ywItOCMfHUuTFtu/PRKKLOJI9HXH1YmJhuNEri7
   K10HQoATuy+7VtTw2eR6aHdmRn4X/0EaIxwcDJMpeoh6kXAnwUu1nrht8
   g=;
X-IronPort-AV: E=Sophos;i="5.91,265,1647302400"; 
   d="scan'208";a="223996123"
Subject: RE: ...\n
Thread-Topic: ...\n
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 31 May 2022 14:52:08 +0000
Received: from EX13D33EUC004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com (Postfix) with ESMTPS id 97B8A40CB9;
        Tue, 31 May 2022 14:52:06 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D33EUC004.ant.amazon.com (10.43.164.63) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 31 May 2022 14:52:05 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.036;
 Tue, 31 May 2022 14:52:05 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Allister, Jack" <jalliste@amazon.com>
CC:     "bp@alien8.de" <bp@alien8.de>,
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
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
Thread-Index: AQHYdPhkNX+wk5QumkS6hY2ybmOpva05D+WAgAABcbA=
Date:   Tue, 31 May 2022 14:52:04 +0000
Message-ID: <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
In-Reply-To: <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.66]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-15.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: 31 May 2022 15:44
> To: Allister, Jack <jalliste@amazon.com>
> Cc: bp@alien8.de; diapop@amazon.co.uk; hpa@zytor.com; jmattson@google.com=
; joro@8bytes.org;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; metikaya@amazon.co.uk;=
 mingo@redhat.com;
> pbonzini@redhat.com; rkrcmar@redhat.com; sean.j.christopherson@intel.com;=
 tglx@linutronix.de;
> vkuznets@redhat.com; wanpengli@tencent.com; x86@kernel.org
> Subject: RE: [EXTERNAL]...\n
>=20
>=20
> On Tue, May 31, 2022 at 02:02:36PM +0000, Jack Allister wrote:
> > The reasoning behind this is that you may want to run a guest at a
> > lower CPU frequency for the purposes of trying to match performance
> > parity between a host of an older CPU type to a newer faster one.
>=20
> That's quite ludicrus. Also, then it should be the host enforcing the
> cpufreq, not the guest.

I'll bite... What's ludicrous about wanting to run a guest at a lower CPU f=
req to minimize observable change in whatever workload it is running?

  Paul
