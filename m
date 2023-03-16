Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F656BD427
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 16:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjCPPm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 11:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjCPPmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 11:42:01 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957F5C48B8;
        Thu, 16 Mar 2023 08:41:25 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h8so2156763plf.10;
        Thu, 16 Mar 2023 08:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678981280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hDj6HHe6QIQSy0m43rHzmd3XSI0d0wloxyDtIEPd/RU=;
        b=ZC0XaRI5LDdOPLc7kmu3d4yJ6J2z7pfXZgPGH3dEAxN0YOuhVFAXh+V4lMMW2YKeir
         vkACoMYwS1Y6SF84UjjKGtwRZkmRHChIoAn7q1aYlq8/A3d7gHKgkw7q3uHC1xFsKllt
         U6tXEQ1lgcYmE92aqKp5MV1XMMiQz7D9oKb64aRkRWXbFkcpRsmgwUcXdFdJJFeeKqHV
         DQevggVSuL6vxclpFT2r/g+TIqRy4LsJsDrggmPPvOWeWYsbwOlZTYua1eI4OrzAVE0R
         A0P6+rE56jWUwUchiYqlO4JUqQ8bXyByN+W1rpEHUCMtkxzepuu3i8An5duDlyZPABBV
         bVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678981280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDj6HHe6QIQSy0m43rHzmd3XSI0d0wloxyDtIEPd/RU=;
        b=2Z2aMYfQd4e6s/9vQ0StWsHJkcsc32njKl/Ge04mLd2vwZA6WSrRXz/2U8N4pRJ8t7
         BS9r0x+7q27QveehX6N2fRznCcQCBbu/JvAwUl94BlT/vzVWUW9npvQhLe36olf3WcWR
         NkJksJxDduXnpnX+BBYyKWVUFqhZSBN9pQ1B8g8MViLRZyzydVAoGWNRxEzgZyItNjYf
         kByeDBOdZZ2VqjeVZl+UvPDwc974HPR0NLLTQC8SmY1W28IwuAxWEsnqqLp8YL/aeCjg
         5FHbZiHJKKnDpG8PrfPMBIi7VxFd8RNUb+NSff2PaV3+cKq5dQRoRnHFcAzj9wliwpct
         0mHA==
X-Gm-Message-State: AO0yUKXT/HhdyirTyogH4dW+yL8g7j6CNheq5I8JGv9xMl47jXFjwR4B
        wtfYhBlfZO/OLTvNVQnkzIw=
X-Google-Smtp-Source: AK7set89o+4AUu9kcgHbviNf8mXzUkYE1K7O/FRk5sxh4x8ea2gqOO8qvmnLzAfJkXVMgx/O7vNEhQ==
X-Received: by 2002:a05:6a20:4c08:b0:d4:6d80:f93a with SMTP id fm8-20020a056a204c0800b000d46d80f93amr3570490pzb.24.1678981279827;
        Thu, 16 Mar 2023 08:41:19 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id j13-20020aa783cd000000b005d3730383a7sm5527127pfn.220.2023.03.16.08.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 08:41:19 -0700 (PDT)
Date:   Thu, 16 Mar 2023 08:41:18 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v13 005/113] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Message-ID: <20230316154118.GC259042@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <0545bd8a7b851d5b53cea16e7e4624b58dd9b71e.1678643052.git.isaku.yamahata@intel.com>
 <70caa84177d8d4c3ace65663992ba4d72f939f4e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <70caa84177d8d4c3ace65663992ba4d72f939f4e.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 10:42:09AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sun, 2023-03-12 at 10:55 -0700, isaku.yamahata@intel.com wrote:
> > +
> > +static inline bool is_td(struct kvm *kvm)
> > +{
> > +	return kvm->arch.vm_type == KVM_X86_PROTECTED_VM;
> > +}
> > +
> 
> KVM_X86_PROTECTED_VM is defined in the next patch, which means this patch cannot
> compile.
> 
> Also, why KVM_X86_PROTECTED_VM == TDX VM?

This part needs to be resolved.
Use KVM_X86_PROTECTED_VM as TDX VM or new type KVM_X86_TDX_VM or other way
to specify VM type.
Given pKVM is coming, dedicated VM type seems better.  I'll switch it to
KVM_X86_TDX_VM next respin.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
