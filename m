Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC227454656
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 13:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbhKQM1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 07:27:20 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59552 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhKQM1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 07:27:19 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637151860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jTHZ6EoZWd9eLQOIAx5PEQLpUvioOeDqCL71qslY/gY=;
        b=YP4r3xPcGKh713J9cav9w5UI5k09TcsYJ8y3gdha1OrphUQzEUScrSJ13Xs/NH0QD3Dr5e
        UBPfPWqXelLHLjZOJN1bU/QGWuw6dIYzKVDQ1aT+oOU5lI0g0T2OyJKN/K16jfvShYhHgl
        HvHo8xNPbdRnbe7DP7g4i++gf1fXFAlb0ddlVNSLAA8tib06jq7xk8z71US4vVcW6SrY+O
        M7TKNYf/cSIL+KiLkCegGz1RdOr14aF+b4w4eNlKZmMKP26/jh0rEl9OGZQj1B1Mq9Cx8V
        1fgv9adG/BQfBcTIsgPz2LPhHnph2WkPMKzo7n25ycb30UgTAARD0QMQIcTQOA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637151860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jTHZ6EoZWd9eLQOIAx5PEQLpUvioOeDqCL71qslY/gY=;
        b=FT7h8a858AWSMh/LAZ8GILP2xdgdI/bEsP0cJf2ydAYFIJQn5fRtk8kLEv5mNSUkJGopA2
        RO6Zt++TABtD29BQ==
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: RE: Thoughts of AMX KVM support based on latest kernel
In-Reply-To: <BN9PR11MB5433D6A1368904D9B748846B8C9A9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <878rxn6h6t.ffs@tglx> <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
 <2e2ab02c-b324-e136-924a-0376040163a8@redhat.com>
 <BN9PR11MB5433D6A1368904D9B748846B8C9A9@BN9PR11MB5433.namprd11.prod.outlook.com>
Date:   Wed, 17 Nov 2021 13:24:19 +0100
Message-ID: <87tugb3r7w.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tian,

On Wed, Nov 17 2021 at 10:15, Tian, Kevin wrote:
> We are not sure whether such trick is worthwhile, since a sane
> guest shouldn't set XFD[AMX]=1 before storing the AMX state. This
> is why we want to seek SDM change to mark out that the software
> should not assume XTILEDATA is still valid when XFD[AMX]=1.

Yes, please. Anything else is just causing too much hackery for no
value.

Thanks,

        tglx
