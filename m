Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D62E480AFC
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 16:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhL1PtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 10:49:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235238AbhL1PtU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Dec 2021 10:49:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640706559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ycaX1I6cQki2ElBFoIZec501uCWjSCGIAPC5v/9/3KM=;
        b=PofkWOqSgs5DfVM7YcE1g8xysggMfrAB1t6a3mZNJZ1Pv4B7oQQzt7kLK+AkzKLtS4Vdm8
        HlbLzeTuxNvzsxEsfCQpzX+lWMSxP4zr8k0nUTqXoPvC2yWVUDX7YW3MMRVngCG2eGhDLY
        atb0efDKXht6XH/e1aoVmQz4mm3spcQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-qGEO2fKnMLu45clp2QDiMQ-1; Tue, 28 Dec 2021 10:49:17 -0500
X-MC-Unique: qGEO2fKnMLu45clp2QDiMQ-1
Received: by mail-ed1-f69.google.com with SMTP id t1-20020a056402524100b003f8500f6e35so13395358edd.8
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 07:49:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ycaX1I6cQki2ElBFoIZec501uCWjSCGIAPC5v/9/3KM=;
        b=7qGB0hQKkOaTg1Bq/QTLMNQULYnW/5DZg98VPGgwq1D/7RquYMfx7UsAl+RQSlD7Hr
         xqXlI2eYvlTYtqm94TVtPfFT4Jiyh8O4S7tutn/ZRWPQqgpM6+wvvO6RWg4H4DfM4NNx
         6e07aIKiQZlRvpARuq7eUMp53iBRhntmElT8bpKKncgHuLsb6EhurwZehGrYMYqFiD4b
         mGLgk4erFK2DOoHGCdky+Y3CNNTYU03AZd2ul65MjD4ds+6B+1deE7LW1WGdfmiAeke8
         Nn5VXViOFdrLfwEg3w0x+yKcVmZ+S/wJawyvXhCxg8LAFwuws7X0T57ofNEM0zmnoa4N
         iwDg==
X-Gm-Message-State: AOAM530UAOGhucOzj9ri9Iz8nsGPdZ01P2NB7pEXlq/8M+I6pJoQmumu
        tuE4l1SvuiNPgn7oGvieXEnJccIODVGqbl/SuZylAqmCvJBqXT/+7cQNsqZFJ31iu3C0uQa8Rf8
        OPGTHVbgT1Maj
X-Received: by 2002:a17:907:6218:: with SMTP id ms24mr18128794ejc.520.1640706556739;
        Tue, 28 Dec 2021 07:49:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVRlq/tAOI51DmzhyS+1JIQQzYL0mPFufqb3TGKXiXLeqn5H3FF3YL0ZuyyqD7t5ua4Rx5Qw==
X-Received: by 2002:a17:907:6218:: with SMTP id ms24mr18128788ejc.520.1640706556555;
        Tue, 28 Dec 2021 07:49:16 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id c7sm96339ejc.208.2021.12.28.07.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 07:49:16 -0800 (PST)
Date:   Tue, 28 Dec 2021 16:49:09 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: selftests: get-reg-list: Add pauth
 configuration
Message-ID: <20211228154909.sig5ltzn6ziolfil@gator.home>
References: <20211228121414.1013250-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211228121414.1013250-1-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 28, 2021 at 12:14:14PM +0000, Marc Zyngier wrote:
> The get-reg-list test ignores the Pointer Authentication features,
> which is a shame now that we have relatively common HW with this feature.
> 
> Define two new configurations (with and without PMU) that exercise the
> KVM capabilities.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 50 +++++++++++++++++++
>  1 file changed, 50 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

