Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76092602F42
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 17:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJRPNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 11:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJRPNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 11:13:42 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B231FBC478
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 08:13:41 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id d26so32976777ejc.8
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 08:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ngFDrkYh7TfNwn3cKsyTj9NZFSvpWOTJCwLE4FnKgSU=;
        b=LG7auiBDm+jf1sMd/H8YfO2YVkDDZ5DW9ctKwMPFzY1OHJFJ97XDUMa1K91CZuf4rw
         vmoW94wTquKSft8eCf8EkWz//J6bu/jxy4oeGSmrivniDMGHmFYtjp+fZ7hH6rQ4iJJ9
         8nSEYgj5nKzs0/i9wcUXMr/jh/wfECYCX+6yrl57Vgj8JW9BtqDiwRClm47UKsk2peA6
         ztYDn8DznNImiSqMai2cJQC9A8dt0bccHBxXUYVB909dIv86bIx3/C5Y3w7SsOdlXTLw
         PGwd3JyJy81q8UJfQwJv62s0xT8dqiIu3D5Vm2s/SEVIrabDdxdE/feH9UDR05jKKK3+
         uRNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ngFDrkYh7TfNwn3cKsyTj9NZFSvpWOTJCwLE4FnKgSU=;
        b=Tk6OtwXikeBC6MjqD1YaucGFIQZl4C1b4/0RpNby0EI6MRxWxMd1JzVXlJ6VOAJVGD
         UdddMi0W0Rg9bhLFB0bGPnqzvihcSGrFHUoY2k6Dx7i717WkKWi8o/lYV4gtCs/wo3o8
         iisQnjzuooshRo/VNb7K/0zVkJ6yGejJ+2cAE/77RfeNimeWqJE5+tBtMe/PzkdwHK6I
         0bugnCvl11ogNaDlrjRAhShuATqmNHM9cop9iy6+mRk6GEkFR7yxwkrFgSWI4fUppZHB
         traoiOnyhs1rOKqPFGd1yp6sIv5D6RiAR4WcmGcN9Ya6QqSKRDdpgRoFzMYk/Dd2AcEY
         DuwA==
X-Gm-Message-State: ACrzQf0YijUFMlmWje5cAKz3udHkMJeafpNHlLb4xjY+1uO/pnlCrypu
        spsYpCAvu20cRu6LJ3N4VlMl/Q==
X-Google-Smtp-Source: AMsMyM5VsSscnj0Yt6uKT9OUKBIQcGNB+oVkvUrofbuFrg2x581bniD3XJvupkVdIqE5x+cIa2clIQ==
X-Received: by 2002:a17:907:94c7:b0:78e:1c4f:51f9 with SMTP id dn7-20020a17090794c700b0078e1c4f51f9mr2961662ejc.200.1666106020078;
        Tue, 18 Oct 2022 08:13:40 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id bo15-20020a0564020b2f00b00456d40f6b73sm9019291edb.87.2022.10.18.08.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 08:13:39 -0700 (PDT)
Date:   Tue, 18 Oct 2022 15:13:36 +0000
From:   Quentin Perret <qperret@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <Y07CoADQH4v7cY5Y@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-13-will@kernel.org>
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

On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> +/* Maximum number of protected VMs that can be created. */
> +#define KVM_MAX_PVMS 255

Nit: I think that limit will apply to non-protected VMs too, at least
initially, so it'd be worth rewording the comment.

Cheers,
Quentin
