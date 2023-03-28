Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F256CC4FF
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjC1PLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 11:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjC1PLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 11:11:30 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8AFEB7D
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 08:10:29 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id b16-20020a17090a991000b0023f803081beso3438411pjp.3
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 08:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680016080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HdZ+ShFbKELJJ4uQifwrSj0aNpPoPSXxJ1YWCsV+NWw=;
        b=TULVgGK5AY9u67apLqSeSri9a06Q1IdJs0BiXYnQDZxtDaE02Bl8uAvHcDNdptMhz/
         ZLtFa1+RlN6IqFoqserOTf2CXozMr3VkiKxtTdvs4NqA3a8nSlyeDgFrIAuDKMjkfqZj
         VyDCbaOBvQDIstDJUT0nPBNG5d+f9Ca4XbdC/S45NPhSodJNJXVVvqlS+FSraYiO0ymT
         yffD/z65aG7Szz9abu3tnSDVMEDDxoo/lZGMl/x/McMKkBTyIc4h1YkEL3D7kk/LMvVT
         FFY4E/XL5TvoQOnmPe47ui1baADtJ8DACSQgpWBIXY+pgFIwpXQZsT1BCCEKOFhzLkN+
         XDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680016080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HdZ+ShFbKELJJ4uQifwrSj0aNpPoPSXxJ1YWCsV+NWw=;
        b=LnQ0wSAdiZelL915U3SDgAJlHovSWb39ehW8RyPIKlh0wQkhoVFLalx7WqETu3tKbg
         drkU2KrpIQSFoC6cDm8rKfl2PDfYs6+cGP7JGYLmFmOHMTmP3BPhWLiBwBIS0ash4xF6
         gsvxlyAwfHtR6pMIGYHjV3cszU7VurRlVe6f6zkX/ihbbylKzyooiDq9k3hL/6PLyrlx
         rrF5YCuuzZOWEhleenKh1NOfF2pqNOdGMeq0EYebEbf8/bOKRgVjaCNZtl0GiDrXuV0p
         Zt5W0Qp1WDO6qNyWBfoGZQsZsRpJPxEqLlqvIYzPScYY3pYtVHN7QJxQSx37QHDGkbH2
         WKFg==
X-Gm-Message-State: AAQBX9fdTztuNHXlPQA6BJIBEThQ4UjYL8qK7CwoyVezxy6zhaP0PvZz
        IMopG1fkJg8dsW6+kyM8DWaWB16Ol3I=
X-Google-Smtp-Source: AKy350blrFLotxTTFiE5gjherTVcUYZ0CAnH8BLcYqn1hrfY+CJ1XCdLu9ZgvPIGk9uBHjKub4ju768Djjc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d38c:b0:23d:35cd:725 with SMTP id
 q12-20020a17090ad38c00b0023d35cd0725mr5012794pju.8.1680016080333; Tue, 28 Mar
 2023 08:08:00 -0700 (PDT)
Date:   Tue, 28 Mar 2023 08:07:58 -0700
In-Reply-To: <620935f7-dd7a-2db6-1ddf-8dae27326f60@intel.com>
Mime-Version: 1.0
References: <20230328050231.3008531-1-seanjc@google.com> <20230328050231.3008531-2-seanjc@google.com>
 <620935f7-dd7a-2db6-1ddf-8dae27326f60@intel.com>
Message-ID: <ZCMCzpAkGV56+ZbS@google.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add define for
 MSR_IA32_PRED_CMD's PRED_CMD_IBPB (bit 0)
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023, Xiaoyao Li wrote:
> On 3/28/2023 1:02 PM, Sean Christopherson wrote:
> > Add a define for PRED_CMD_IBPB and use it to replace the open coded '1' in
> > the nVMX library.
> 
> What does nVMX mean here?

Nested VMX.  From KUT's perspective, the testing exists to validate KVM's nested
VMX implementation.  If it's at all confusing, I'll drop the 'n'  And we've already
established that KUT can be used on bare metal, even if that's not the primary use
case.
