Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1FB740737
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjF1Abe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjF1Abd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:31:33 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790672738;
        Tue, 27 Jun 2023 17:31:32 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-666ecf9a0ceso3036508b3a.2;
        Tue, 27 Jun 2023 17:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687912292; x=1690504292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XM8hQAD7sAgZi8pW6aajDq5y68kjdX8oGtV+xaawf/U=;
        b=XzW9jw0ZxclnHhqqY5hoQeITwmGF+eQf2Z31WtwKKbhh60/XHAeMMSf6wOVrjm2uxY
         cdOCnTaywYcknu1Ii3oLpVo0Eu3SfnU9ED5/z/6HmXyhEE/HI1fAipNkBI8aDNFqm0th
         rg1g93Qk5IHpUsGOTCceFrFsy/5dgspzAiu5CbAU72t/aaMXA/JWdRmFQxhuE1AK+c4E
         mxdlKkIouwhfDVAIvE9fiCFRMT393DAjb70PjVc195xSFbF+4QPoi0n0SBzIHKOKhJAf
         aB9AjyOXFViP+NlXmfCCtxxhfCLPLuQRJNbWVjNj4dyY9RHuk3u1Rru51gRsFJqNbPvg
         /3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687912292; x=1690504292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XM8hQAD7sAgZi8pW6aajDq5y68kjdX8oGtV+xaawf/U=;
        b=AfkASGZGDuHyrZCs/SJ4PQFbvGU2ErtBo7C2aE6nURCRXlm5NJ+XGc24qRjH/M8ZJB
         L6jN/WIaEoKpdVHzq7Yg2Tz7pIfMLmKR9nMWTFzsBBLCegHSbpdWvkUyxiBhNaag9dc8
         YBY9CtrNnHhZaVUhqQhFgrwlBEvt+kb/nWDW5HGDJ44B/nMKUn+N6du1x1IORmACaSs0
         /HoaKjkdEz9aLuxLcU+vY1LdEOlDrGtxjC0sEu9VbtdSPhH3+Zpps/lw+h5hHXovZerZ
         YuQV0drW0A9eDtRT34Kdo1fkJH7faCsyTWOiEVR67GG6YngDcGT/ps0UTBb26b8kTQ0L
         Zdeg==
X-Gm-Message-State: AC+VfDy3PG+nIS16/cOohGVmdbTxoVdz6GWX6oY9Texit6TVXUYUMI7G
        U8sUdGP946uKD7SgioTU76o=
X-Google-Smtp-Source: ACHHUZ57emkUxF4X0LBpxahJKoGiTEUqZKon2TnYW9by/gNFqU28R426K+gVZbAIth3A1FUOf2u0GQ==
X-Received: by 2002:a05:6a00:1309:b0:663:5624:6fde with SMTP id j9-20020a056a00130900b0066356246fdemr29717928pfu.22.1687912291885;
        Tue, 27 Jun 2023 17:31:31 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id x48-20020a056a000bf000b0064d32771fa8sm1354780pfu.134.2023.06.27.17.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:31:31 -0700 (PDT)
Date:   Tue, 27 Jun 2023 17:31:30 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
        "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, isaku.yamahata@gmail.com
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230628003130.GB3629671@ls.amr.corp.intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
 <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
 <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
 <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 10:37:58PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > > 
> > > +/*
> > > + * Do the module global initialization if not done yet.
> > > + * It's always called with interrupts and preemption disabled.
> > > + */
> > 
> > If interrupts are always disabled why do you need _irqsave()?
> > 
> 
> I'll remove the _irqsave().
> 
> AFAICT Isaku preferred this for additional security, but this is not necessary.

It's because the lockdep complains.  Anyway, it's save to remove _irqsave as
discussed with you.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
