Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B306105C0
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiJ0W3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235203AbiJ0W3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:29:07 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FB0B18F6;
        Thu, 27 Oct 2022 15:29:06 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 3-20020a17090a0f8300b00212d5cd4e5eso8041248pjz.4;
        Thu, 27 Oct 2022 15:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AG4F1mROTpr5u4kkYvWVpYOMl+6kqWe5+k0RORa+c4g=;
        b=T4vZkZRWPUNObV5wj1y8eBsDMmxjq/rVfbjt4764bS+he3bH07MXwrr9le5PAECL1o
         qz/6G9wiU6YTeOp57WDKnx7zkVGAxNyuAnJq+RcN/cBsj1QrEGBFvb8VHj8gL/033AeP
         RhU3ACCMAqbkUJeQ0j1x8qPljx6Y7l4dgh8y/O5W+ihmkuHLuLHGK7FocHqAgMfigrpa
         f5ITNxq3aKjo9R3RHyit3MSBX1MogKvmRmehUEqLEXL30RV2e8bHVB6uqg5fFa7Ovgx7
         RX+4oCE6zwoVlw2YKrcocUuX7f1x1XsEyllMPLVHziI8+/KoDYitN2i3GUKj7gyHFPk1
         UMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AG4F1mROTpr5u4kkYvWVpYOMl+6kqWe5+k0RORa+c4g=;
        b=l8TT8oXlESg+XFyXXvMw2PX7sIhfzy4HNoIF3+K2LhDCygsKrYH3Aw2CPM07xJf6uu
         GtIuONJCoxC9RPSLkGwL552ke9Z5XcSEj1gj6PYPuNZUfqN5yi7OoyijPGyXcNH5B3g/
         QDbzN9QaZXOcq6Dvi5zYv5ZAlfEaDuaVuaJkxX9mtC8ccYxdqfwZl3vMV++jnUsYEEYn
         OhmBfWiWcrZfoEDLvRlnashpRmfvTgLinAIofcRoBTfCMyWAZZHVpLg18PY4WtqyFoUZ
         Wl2rEfTmXiQYd7XdXEb6UysIUFawONOiUMcU7epACXC5VdUfRmXXJdfA+mYS4nuwceTd
         pwhQ==
X-Gm-Message-State: ACrzQf0z0kXFeTrpp4qmlKa5bExwCEBZAvT4tAJZo//r4edNrYN7ZD3c
        wWbLqJS+I0UJVBYlF8uijto=
X-Google-Smtp-Source: AMsMyM612gH6T9pOfKHLdz1UcPyO4sKgtZrlaDV8LzFxGi7671k9SzAi8/ROucP9RznXGiDfXU0qaA==
X-Received: by 2002:a17:903:124e:b0:178:6946:a2ba with SMTP id u14-20020a170903124e00b001786946a2bamr51281893plh.89.1666909706755;
        Thu, 27 Oct 2022 15:28:26 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id x184-20020a6263c1000000b00561b3ee73f6sm1676604pfb.144.2022.10.27.15.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 15:28:26 -0700 (PDT)
Date:   Thu, 27 Oct 2022 15:28:24 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v6 01/21] x86/tdx: Use enum to define page level of TDX
 supported page sizes
Message-ID: <20221027222824.GA4101506@ls.amr.corp.intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
 <8a5b40d43f8b993a48b99d6647b16a82b433627c.1666824663.git.kai.huang@intel.com>
 <80e8111b-76a2-4999-782b-fdd4b9f425fa@intel.com>
 <d19c81ef34856f72c964322a7390d6fa21976e6f.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d19c81ef34856f72c964322a7390d6fa21976e6f.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022 at 08:42:16AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2022-10-27 at 15:08 +0800, Li, Xiaoyao wrote:
> > > @@ -663,27 +662,16 @@ static bool try_accept_one(phys_addr_t *start,
> > > unsigned long len,
> > >    	if (len < accept_size)
> > >    		return false;
> > >    
> > > +	/* TDX only supports 4K/2M/1G page sizes */
> > 
> > yes, a page can be mapped as 1G size to TD via secure/shared EPT. But 
> > for this particular TDX_ACCEPT_PAGE case, it only supports 4K and 2M 
> > currently, which is defined in TDX module spec.
> 
> I checked the TDX module public spec, and it appears you are right.  But I am
> not sure whether it will be changed in the future?
> 
> Anyway this patch doesn't intend to bring any functional change (I should have
> stated this in the changelog), so I think fixing to this, if ever needed, should
> be another patch.
> 
> Hi Isaku,
> 
> You suggested to introduce a helper, but this reminds me how KVM is going to use
> this helper? KVM secure EPT can accept more levels than try_accept_one().
> 
> Perhaps I can just get rid of this helper? TDX host series only needs some
> definitions to represent 4K/2M/1G page to get rid of using magic numbers.

Ok, let remove the helper function. The usage seems different from KVM case.
In KVM side, it can introduce its own helper.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
