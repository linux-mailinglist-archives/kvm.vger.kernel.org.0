Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D7357B318
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 10:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbiGTIkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 04:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238566AbiGTIkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 04:40:10 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3568239D
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 01:40:06 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bh13so15800798pgb.4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 01:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=igHcvbbNIBEuhZc+DjfEJd6g7hQ4R/AxL0/SU2gdyWo=;
        b=roVHS8GqR9tX81QUvNAwTO3rEmwU/Z7n4o3+GbP1WjWEsaxBtQQSABAXlyUcYr6LuJ
         dtADQYwCslhmuwiu7Z6qn5ktJFp7VTIZMUE/DxCzf4iig8pOVeKnNLDS2Kx6K0IjZnHl
         ycZs0rKfB0VcoEIJBLrEE0QhjD8Liu+SXs/qFtvOi+w9IxnvuxmCfm1idG5tkjjCFJ9B
         iXeC/NY8n2efQm1dKqmIgavKVmyde5b+e8uk2DkiAoZk1Os8LnS7RcUAp0gkiKriJ6Pp
         ohObDwVencwUndBDLqeXXhbAhLxTCR92p0R24+l9coeXdGd6fO93iP48pfLHUTnpqEI1
         0C9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=igHcvbbNIBEuhZc+DjfEJd6g7hQ4R/AxL0/SU2gdyWo=;
        b=cGKZFlnI5AJvQEvaF1cmwIe51tvPibLj2+7RQkilYBgoapTZgPXae2P/MQcv7O1J15
         VPP0fWwMM/JUFzAxSuou/uCeNqwJhUVmeh/2dBnyQyUVb2bI0qONb9FZNX8x5/mkwtNY
         bcn1lnU5VV+4cOm9T24lEHMM+nDnb+qzzcohun3Obwk+C4qub4N4J0g6dc76K5Nl/fse
         8c5Xi0xhVU939hzeY0rCZJIYOHj64gJ5wzpJoPkIk4HbbB7kCNBj7qfIKx8e8Vz8CzXk
         3BqCWm3FauYCIWR72C0lKTLc54bnWckSCkf8mLojsXlGaRh5HZgmt3I7/LPhPQphpgdG
         vtWw==
X-Gm-Message-State: AJIora8JdzIZ6MyDutWvCl+r+22hKT+dP9zrNPTWIoMvF3rUDJjAUwfc
        AHq4Pg/kTcKusSt+9VlOr0PA2A==
X-Google-Smtp-Source: AGRyM1tzAi1dyHMpn7ivb+IEqLwTeryX+s06VifqPmCo3roiLkBrS3nZgdI466Wl6k5WeyOfSiRpeA==
X-Received: by 2002:a63:df15:0:b0:411:51f2:cc2a with SMTP id u21-20020a63df15000000b0041151f2cc2amr32751610pgg.533.1658306405477;
        Wed, 20 Jul 2022 01:40:05 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903110d00b0016c27561454sm13456239plh.283.2022.07.20.01.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 01:40:04 -0700 (PDT)
Date:   Wed, 20 Jul 2022 01:40:01 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <Yte/YXWYSikyQcqh@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edyhz68i.wl-maz@kernel.org>
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

On Tue, Jul 19, 2022 at 12:34:05PM +0100, Marc Zyngier wrote:
> On Mon, 18 Jul 2022 16:49:10 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > A chained event overflowing on the low counter can set the overflow flag
> > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > overflow.
> 
> Isn't this indicative of a bug in the KVM emulation? To be honest, the
> pseudocode looks odd. It says:
> 
> <quote>
> 	if old_value<64:ovflw> != new_value<64:ovflw> then
> 	    PMOVSSET_EL0<idx> = '1';
> 	    PMOVSCLR_EL0<idx> = '1';
> </quote>
> 
> which I find remarkably ambiguous. Is this setting and clearing the
> overflow bit? Or setting it in the single register that backs the two
> accessors in whatever way it can?
> 
> If it is the second interpretation that is correct, then KVM
> definitely needs fixing

I think it's the second, as those two "= '1'" apply to the non-chained
counters case as well, which should definitely set the bit in PMOVSSET.

> (though this looks pretty involved for
> anything that isn't a SWINC event).

Ah, I see, there's a pretty convenient kvm_pmu_software_increment() for
SWINC, but a non-SWINC event is implemented as a single 64-bit perf
event.

Thanks,
Ricardo

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
