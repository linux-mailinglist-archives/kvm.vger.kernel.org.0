Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E609D63D98B
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 16:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiK3Pgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 10:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiK3Pgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 10:36:38 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7B81C921
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 07:36:37 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id k5so16001366pjo.5
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 07:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oK8gN0YgVAu7NkEZH3khUXgKx/TyMqni0qECFdFyL/8=;
        b=nehcrulzsv1SkJ5g/5jzmV1bbVDxkpK7YfJ8cc88N5b9GLOamaq9qvGcvUesp9Txvh
         gPEiD4q5KY2nalKX+nz4ZiIACz6hY80lBxZ/VyUIRYNYIRJ4yhewj4gyvidWzOJMigM2
         55mxDtK5kuvp7eSSI3H5yXYj3OO8f13d+jrL9L7+O6qAPCX5P2fVnT7HkQzsfymgHoiJ
         TDUDlYGpdnBNoMMxh6GR056mnpzjmGlFULP1m/few/WO9dhsIagh//PyPSXuS5HxEqYM
         4MOzF9IfP7YedRim+zxlp+l/YvU/6vVGLOxXSw+3TzYHrnvOe/kcHGStEK1sUNvcblCi
         hZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oK8gN0YgVAu7NkEZH3khUXgKx/TyMqni0qECFdFyL/8=;
        b=OXnABXqY3qzp56n2cCnTxOf6JTDkkJnOWrmt/GrdJdFAcPVvXtu3wPnbPaUXmGTQte
         F2Xqs1ctCB9Cu7+lVoUrzrWRsYuv9yomLIqGyNi4SWziNqJcM99mUx88d2Ph0wvhy12T
         WQ2YBTj/DWrrXKtm05mtVBP0AcjmwWfdtDStydhr2g3ZC5xokfM76sVBMWurV2ir4UYE
         6jRfXBAFct0xgZgMcbEwtDW01NesqVhiFMRsq3ppvQlAwtIoyPzAnqxTRq+PEdefemsD
         N6RvchjS9+u8TeAyy6Br+d9Bd4DJxfvu/6F4L8R4InsH5GuubkgS15PanXyEo11i56mT
         xnNw==
X-Gm-Message-State: ANoB5plk/9nKCioHFWfnAQBoMd/CK4tNYbbM1zLN4EnEFV00i7KDHoyS
        89JHJDcmj8utyaFMTRhiqjvZlA==
X-Google-Smtp-Source: AA0mqf77p/L0ry35v6WlvSEwjJVAyD875zIFzALBwMusXtcWqIAnV1eH+XFkSONGVgPexXhfsWr6VA==
X-Received: by 2002:a17:902:d550:b0:189:7bfe:1eb5 with SMTP id z16-20020a170902d55000b001897bfe1eb5mr20434854plf.9.1669822596615;
        Wed, 30 Nov 2022 07:36:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m8-20020a170902db0800b001895f7c8a71sm1656193plx.97.2022.11.30.07.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:36:36 -0800 (PST)
Date:   Wed, 30 Nov 2022 15:36:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lei Wang <lei4.wang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: Change non-existent ioctl comment
 "KVM_CREATE_MEMORY_REGION" to "KVM_SET_MEMORY_REGION"
Message-ID: <Y4d4gQd7cYDIjfWB@google.com>
References: <20221130064325.386359-1-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130064325.386359-1-lei4.wang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022, Lei Wang wrote:
> ioctl "KVM_CREATE_MEMORY_REGION" doesn't exist and should be
> "KVM_SET_MEMORY_REGION", change the comment.

Heh, no need, KVM_SET_MEMORY_REGION will soon not exist either.

https://lore.kernel.org/all/Y4T+SY9SZIRFBdBM@google.com
