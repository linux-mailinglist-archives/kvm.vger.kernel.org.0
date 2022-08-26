Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDE65A1FFD
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 06:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244798AbiHZEs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 00:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244728AbiHZEsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 00:48:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C3BCE44E;
        Thu, 25 Aug 2022 21:48:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso7003237pjl.1;
        Thu, 25 Aug 2022 21:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=gWomNih8e6LKSH0jfDGvuNkG1/sn2irHoorr1tZHc14=;
        b=MoYj1/VkxWWCh7Do2ZejjP0fPvkVMB/8vXDLu5GOXFX2tMX2zxxpj2E8E+epVmhHv6
         Ne64mxPnMk4HfJUGxm/nVw+iiQ2l9QVXja5AMZV9PzwTmvv17V3T5Nobk38UkY1N369C
         kx1/en9fwEANVmG6pBrGEMsrtcXbsCiriEF2FjIYJTzQudioO7Gm+aogGI0fTkaq2nK5
         0quyVyP/X8FozZEZWGGdlzDO3C4NY2S7FsUcy2TNONs6QkgBNeV/CIYOsVQ5cOaYFiTx
         F8HJrgbw8TsLXZwsnPzTsOtZbH1pZ52eoghWvt2NsLNtfJDBctP8XE+BzXl3hhOrdiEe
         hx6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=gWomNih8e6LKSH0jfDGvuNkG1/sn2irHoorr1tZHc14=;
        b=iZbO5L6cy/DWASCji0hCv9sQcEUi3rWJWdqi8JK85RfCUCpS058pIrj+BD1zqWkjDT
         laGJV/h8Zljy1wlSpTI2sT9OiVe2l8Xoswzat1cibU8dk1/53FvEQwv0Amf+0B1kk75J
         MiJLBzX8eXfnuDt4j+XD01nUYVk9RH2QDi34dSnm7hCbnuxY5B/T2Uqg0rBtPaju0pF5
         GibcbUDhD0uc9qIFS4HJZdG/IJIv6hcTP4s1PWEXxBOPGGuNljeC17ZpsZ77WBiCQb8B
         OuuxcAlrohdN12yxdcBAAzsJDk7v3GDC8WDG6iQWOBertZ9MKxop2QcMxmBF90TKfojK
         dLzw==
X-Gm-Message-State: ACgBeo3PVk3NFWx68fMXaHQbi3YwPBvm/v5Ob+PGswDDCLE52RjaOjBm
        mbuAprdGhM3AfKcrVbCr2SM=
X-Google-Smtp-Source: AA6agR4vHZzYPFX0fkT5JVvgc46od6kvuDrV9tXaZmu8YVbWw0sLXbqt9Es3DU9YXHfWwTVVmgv14A==
X-Received: by 2002:a17:90a:7f89:b0:1fa:ad33:7289 with SMTP id m9-20020a17090a7f8900b001faad337289mr2432002pjl.173.1661489299947;
        Thu, 25 Aug 2022 21:48:19 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id x15-20020a62860f000000b0053640880313sm549570pfd.46.2022.08.25.21.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 21:48:19 -0700 (PDT)
Date:   Thu, 25 Aug 2022 21:48:17 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Binbin Wu <binbin.wu@linux.intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 018/103] KVM: TDX: Stub in tdx.h with structs,
 accessors, and VMCS helpers
Message-ID: <20220826044817.GE2538772@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <d88e0cee35b70d86493d5a71becffa4ab5c5d97c.1659854790.git.isaku.yamahata@intel.com>
 <651c33a5-4b9b-927f-cb04-ec20b8c3d730@linux.intel.com>
 <YwT0+DO4AuO1xL82@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwT0+DO4AuO1xL82@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022 at 03:40:40PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Tue, Aug 23, 2022, Binbin Wu wrote:
> > 
> > On 2022/8/8 6:01, isaku.yamahata@intel.com wrote:
> > > +static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
> > > +{
> > > +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) & 0x1,
> > > +			 "Read/Write to TD VMCS *_HIGH fields not supported");
> > > +
> > > +	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
> > > +
> > > +	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
> > > +			 (((field) & 0x6000) == 0x2000 ||
> > > +			  ((field) & 0x6000) == 0x6000),
> > > +			 "Invalid TD VMCS access for 64-bit field");
> > 
> > if bits is 64 here, "bits != 64" is false, how could this check for "Invalid
> > TD VMCS access for 64-bit field"?
> 
> Bits 14:13 of the encoding, which is extracted by "(field) & 0x6000", encodes the
> width of the VMCS field.  Bit 0 of the encoding, "(field) & 0x1" above, is a modifier
> that is only relevant when operating in 32-bit mode, and is disallowed because TDX is
> 64-bit only.
> 
> This yields four possibilities for TDX:
> 
>   (field) & 0x6000) == 0x0000 : 16-bit field
>   (field) & 0x6000) == 0x2000 : 64-bit field
>   (field) & 0x6000) == 0x4000 : 32-bit field
>   (field) & 0x6000) == 0x6000 : 64-bit field (technically "natural width", but
>                                               effectively 64-bit because TDX is
> 					      64-bit only)
> 
> The assertion is that if the encoding indicates a 64-bit field (0x2000 or 0x6000),
> then the number of bits KVM is accessing must be '64'.  The below assertions do
> the same thing for 32-bit and 16-bit fields.

Thanks for explanation. I've updated it as follows to use symbolic value.

#define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
#define VMCS_ENC_ACCESS_TYPE_FULL	0x0UL
#define VMCS_ENC_ACCESS_TYPE_HIGH	0x1UL
#define VMCS_ENC_ACCESS_TYPE(field)	((field) & VMCS_ENC_ACCESS_TYPE_MASK)

	/* TDX is 64bit only.  HIGH field isn't supported. */
	BUILD_BUG_ON_MSG(__builtin_constant_p(field) &&
			 VMCS_ENC_ACCESS_TYPE(field) == VMCS_ENC_ACCESS_TYPE_HIGH,
			 "Read/Write to TD VMCS *_HIGH fields not supported");

	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);

#define VMCS_ENC_WIDTH_MASK	GENMASK_UL(14, 13)
#define VMCS_ENC_WIDTH_16BIT	(0UL << 13)
#define VMCS_ENC_WIDTH_64BIT	(1UL << 13)
#define VMCS_ENC_WIDTH_32BIT	(2UL << 13)
#define VMCS_ENC_WIDTH_NATURAL	(3UL << 13)
#define VMCS_ENC_WIDTH(field)	((field) & VMCS_ENC_WIDTH_MASK)

	/* TDX is 64bit only.  i.e. natural width = 64bit. */
	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
			 (VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_64BIT ||
			  VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_NATURAL),
			 "Invalid TD VMCS access for 64-bit field");
	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_32BIT,
			 "Invalid TD VMCS access for 32-bit field");
	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_16BIT,
			 "Invalid TD VMCS access for 16-bit field");

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
