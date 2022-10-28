Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63230610E0C
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 12:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJ1KBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 06:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiJ1KB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 06:01:27 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51C573932
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:01:24 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id f7so1457808edc.6
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7v1ISLFixnZeqqEYSmtAp/p3bYM7Zmro7nbWQ4w9f6M=;
        b=qVfHTLEw9mmR79uzZzY5uAswymulVZPsimG3IxxJGxMVN4HQ1p+pyn8uE+DVo5IAFe
         CSRZCDLNHEBeltUqTevMFnZTA2MG+BIQ84bif3eVJTUAD628nk16G7xg8a26EHecdljd
         McRSaD3GcW3MOZS3Qryb3s/6Vfre0NpYy10cHK2l+FGoK/P+bKnzEFAtkUkrPnWQMc35
         4cTwEj4QMUj5lvayvT2z95j8Jrd1i8ifwRlSUF43I3qs5Vcx24Ey4OM/xaLUFb2XYz2p
         3sLK77Yve8raKwQaKR19XjGSSP4F6DD5OliTXbPLcT7+tcUI8DE8nSIvU73aHSf56nGJ
         QSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7v1ISLFixnZeqqEYSmtAp/p3bYM7Zmro7nbWQ4w9f6M=;
        b=B9T08tUu4qsqBrJkq5G927POCKIOQFnhqzXtYruS0WEukeqHsNqyKUNsPbwOUqhQPg
         kne2YLj1NhuK6N8YEKSe0MpUScFqX1k3b5NX8WjIChTj78neRDqbYWGB1kHisQtTYYkc
         JMmpdVYPZc6Bi/3XUtmJakZDu1gsG5JGSPm23rsXGRlqB5EsOZzh6ollrBGKGXBKWBSB
         /ayp+5egvhzjQW3QswNO77CMCn3dmIqI3UlRWQ6B1SR1f2wkqqRcnZg5gdeWogd0jhoT
         82NJndw9T14sUpB1CuiC74m0QxCxVUYl/dewe7L3kK6XWcrrzeLnyqQkT1fDOwBVYK7h
         UvjQ==
X-Gm-Message-State: ACrzQf0FDVyuImjhtowf9tpOfatn/tQP2TBw2tzlG5yoUZthbWDVU7PB
        ySh8oEJMDd/0czfoRTt5TyML4g==
X-Google-Smtp-Source: AMsMyM5nToiMyOv2zUG2fek3v8wNMGTJ2X1qP78wOUNi+QbytqKpZx4U9KsQIDIDML1aw6n90hEHyg==
X-Received: by 2002:a05:6402:4446:b0:457:eebd:fe52 with SMTP id o6-20020a056402444600b00457eebdfe52mr7428106edb.234.1666951282993;
        Fri, 28 Oct 2022 03:01:22 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id l7-20020a170906414700b007933047f923sm1975152ejk.118.2022.10.28.03.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 03:01:22 -0700 (PDT)
Date:   Fri, 28 Oct 2022 10:01:19 +0000
From:   Quentin Perret <qperret@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>,
        kernel-team@android.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 06/25] KVM: arm64: Implement do_donate() helper for
 donating memory
Message-ID: <Y1uob0tsQK1AVR9D@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-7-will@kernel.org>
 <Y1uKRkFHve6S4JcP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1uKRkFHve6S4JcP@google.com>
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

On Friday 28 Oct 2022 at 07:52:38 (+0000), Oliver Upton wrote:
> Is the intention of this infra to support memory donations between more
> than just the host + hyp components? This patch goes out of its way to
> build some generic helpers for things, but it isn't immediately obvious
> why that is necessary for just two supported state transitions.

Yup, the plan is to use all this infrastructure for host-guest and
host-trustzone transitions, but that's indeed not very obvious from the
patch. We should probably mention that in the commit message.
