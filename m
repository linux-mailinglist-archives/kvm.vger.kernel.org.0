Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716584546B1
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 13:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhKQM4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 07:56:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229974AbhKQM4u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 07:56:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637153631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hCr3mpc0+gqqCFUlSOYuusybF0Be7M3y+C4STdZJbDs=;
        b=gGUClAcKNn3ah8iFKGHPAdGZYcaBV1SjZXS27ToIfm/HnK71ej7t9bEBuJ7SD96TO/adgR
        IwEqfw+vovNrdBR9UBMIY4sPFBJEJVHDc2GN08wL0f2ws/sWMokyWh/xIEcfrDTAkfJxhP
        RMNOvv+BM2bXk4IalMk1cC6otMyNE48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-2GHNg5TUOl6Az41pxzOHUQ-1; Wed, 17 Nov 2021 07:53:48 -0500
X-MC-Unique: 2GHNg5TUOl6Az41pxzOHUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3199B15720;
        Wed, 17 Nov 2021 12:53:46 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FF4E5F4E0;
        Wed, 17 Nov 2021 12:53:43 +0000 (UTC)
Message-ID: <c7d87723-5533-257f-fbf0-ecd3a0b96602@redhat.com>
Date:   Wed, 17 Nov 2021 13:53:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Thoughts of AMX KVM support based on latest kernel
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
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
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <878rxn6h6t.ffs@tglx> <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
 <2e2ab02c-b324-e136-924a-0376040163a8@redhat.com>
 <BN9PR11MB5433D6A1368904D9B748846B8C9A9@BN9PR11MB5433.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BN9PR11MB5433D6A1368904D9B748846B8C9A9@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 11:15, Tian, Kevin wrote:
> We are not sure whether such trick is worthwhile, since a sane
> guest shouldn't set XFD[AMX]=1 before storing the AMX state. This
> is why we want to seek SDM change to mark out that the software
> should not assume XTILEDATA is still valid when XFD[AMX]=1.

Okay, I just don't want it to be called out as virtualization specific.

It doesn't have to happen in current processors, but it should be 
architecturally valid behavior to clear the processor's state as soon as 
a bit in XFD is set to 1.

Paolo

