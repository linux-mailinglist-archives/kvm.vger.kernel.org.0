Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A545333AB
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 00:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242486AbiEXWvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 18:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240956AbiEXWuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 18:50:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 603D963397
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 15:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653432650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BCd+QNLniNzlF6W7H/ca6kckSQBoa9VguXTAzz3osLE=;
        b=Z7vLg+zV1JtJ9V3YcMKs/fnuwR4PZNKdNO35HkE7SkNZFG46Rf8uc2rEzNFRa3eO5k19Jb
        6bvWpZGRklaNrgfy4Wq4XZftH1qcPduQnXbNP2Z6ISPlD6SoS6wt0jNHQj+h7YxYmiSF8T
        TmkomxbAgetFQpUSqy3Adyjv3jjH4jA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-7uET9aKuMXuCNKfi8jc-Fg-1; Tue, 24 May 2022 18:50:49 -0400
X-MC-Unique: 7uET9aKuMXuCNKfi8jc-Fg-1
Received: by mail-il1-f199.google.com with SMTP id r13-20020a056e0219cd00b002d1bc061d8eso3190472ill.19
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 15:50:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=BCd+QNLniNzlF6W7H/ca6kckSQBoa9VguXTAzz3osLE=;
        b=26J2pINkfnZ8CjegcVc0ziLmHKEsdY8hKenRLMHhlLZ+73WSwxvjnYr9irCctCnBKK
         wLKQ5kFMi7BFZzH/PihTq+sAbwF+jADr8UT7yDy70Cfr4sZA0VtvuUcSdwjyK87DdrVB
         ZsiLNutPhp9QSHPU0g0Xo/wJYzPGQqUw+6vAAvjOgvG3ZEjm2LK8GNp732cn2kLxgHnN
         RubIl2ZF1Rg0T7Ms8rMbd5svYmtkv7n6a7KOZrl28HEY3DaZAKyQ4dtjhS7t1POZc19e
         2b29QuRtliYDwz02AHDcqh1UqcpvwvsQDmBS6mFBEjLY4Osa5hPzmuq1GKbhFiqe0pV7
         kkcg==
X-Gm-Message-State: AOAM531RhSciAQH9S+VUgnaqzJQaWVX6+afe9KEQSM7oEDnu49VlI6Xm
        DdNF2C6LXrug3qWPz5tYzCaHHQ9rcnsCzq7R7iWzfGoZtfbOv82ZzscAxxVQGRPr8+CYfqulFv6
        kGiJK0I/9HiXb
X-Received: by 2002:a02:bb19:0:b0:32e:8618:9f92 with SMTP id y25-20020a02bb19000000b0032e86189f92mr14374594jan.320.1653432648749;
        Tue, 24 May 2022 15:50:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznIk1GBgvr8+3XKsMI2OkYQ8lU6GD289skiZVi1Gf2Iw+kqvEFVkFnHIn2gX38ZBn0oWVREQ==
X-Received: by 2002:a02:bb19:0:b0:32e:8618:9f92 with SMTP id y25-20020a02bb19000000b0032e86189f92mr14374574jan.320.1653432648498;
        Tue, 24 May 2022 15:50:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q46-20020a027b2e000000b0032e43cb7344sm3731662jac.146.2022.05.24.15.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 15:50:48 -0700 (PDT)
Date:   Tue, 24 May 2022 16:50:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v8 11/22] KVM: s390: pci: add basic kvm_zdev structure
Message-ID: <20220524165046.69f0d84a.alex.williamson@redhat.com>
In-Reply-To: <20220524185907.140285-12-mjrosato@linux.ibm.com>
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
        <20220524185907.140285-12-mjrosato@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 May 2022 14:58:56 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> new file mode 100644
> index 000000000000..21c2be5c2713
> --- /dev/null
> +++ b/arch/s390/kvm/pci.c
> @@ -0,0 +1,36 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * s390 kvm PCI passthrough support
> + *
> + * Copyright IBM Corp. 2022
> + *
> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <linux/pci.h>
> +#include "pci.h"
> +
> +static int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
> +{
> +	struct kvm_zdev *kzdev;
> +
> +	kzdev = kzalloc(sizeof(struct kvm_zdev), GFP_KERNEL);
> +	if (!kzdev)
> +		return -ENOMEM;
> +
> +	kzdev->zdev = zdev;
> +	zdev->kzdev = kzdev;
> +
> +	return 0;
> +}
> +
> +static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
> +{
> +	struct kvm_zdev *kzdev;
> +
> +	kzdev = zdev->kzdev;
> +	WARN_ON(kzdev->zdev != zdev);
> +	zdev->kzdev = 0;

I imagine this should be s/0/NULL/, right?  I feel like there was a
recent similar discussion, but I can't think of any unique search terms
to sort it out of my inbox.  Thanks,

Alex

