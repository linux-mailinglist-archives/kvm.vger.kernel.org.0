Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77ED7728622
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 19:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236515AbjFHRTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 13:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbjFHRTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 13:19:08 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6495269A
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 10:19:07 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b24eba185cso5454725ad.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 10:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686244747; x=1688836747;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xn4z4bAdLLnUlD27MUprwNeTY3jrE96t84qZ964f9xY=;
        b=A7nR4+SOsuhrP4/mJAD4mWHu+cMDM2QkXpBSOkdYLrelvxn+IvdhuS6cxi5mB4yiam
         ogbRfUtaU9t3ZBBMl/KXuDl85TOjXMPFwZHjC7A/0q2tY6RiF0KYwJ+kxQbJJ9JQa4/g
         N7yY2aL1r8T5znpL37Uev3UBg2SnMwqQwf2rvoW72nmShobFz5deiPceOT/4YkJA4Bcu
         JsdfiA4vZhbx43LJOe/blRxtHReFCPL/+/M0oKkBarN6bNOATxsuCteuMZUdjdDPTikD
         qrqcaff/skuy4qFqDouHZP41H9lPYRm654HcGpZO27UthFcqYPc6vZ6J88FbrCDT+o0D
         NUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686244747; x=1688836747;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xn4z4bAdLLnUlD27MUprwNeTY3jrE96t84qZ964f9xY=;
        b=OyzVh13j4KndaAG0WAK/p2wKjsiMu77AwclzXRhXluTZgdGatKAQpHg4FZGJvhXtr5
         wUv5VWikEEwiYEgjdfru2Wa8cYwMKmockM/TMrvYm8w8VVBFs8MUXSpDtdiEslBtwVEd
         hlTcDIu6SjQ11hY40YFZxQNpPTXIzvNPmuQHeSzQ+gQ/7S4dVJ7ECb/DatJ3ZTJyHUwZ
         WQSlfvGSyv0VeWKSFKx6JHaSJXe69rmhb2wQ1ZDSkLVLPsZTDbtzdlxRNOluRDD0U05Y
         OYsqSnPwfqG0VmmWVUzD9MkYw5m+6YI55HStxqlaI0xgmORAg2fZu1cRPBOR862L627p
         yc2g==
X-Gm-Message-State: AC+VfDzLd9wV262oCO1Sv100GT1qGItWkSS8t6ZR3e7xDcgwMxqQs96w
        XsrXSSxPXbf2LKdy5y4Fcww=
X-Google-Smtp-Source: ACHHUZ7adI2YgI6vjLXTvVu6AZpT3Ndk7WpCL9qLv9m7+wBNFY63OV6LQ4FpJW8k1QuodPQZnNrIow==
X-Received: by 2002:a17:902:b20e:b0:1b1:9218:6bf9 with SMTP id t14-20020a170902b20e00b001b192186bf9mr5547527plr.43.1686244746610;
        Thu, 08 Jun 2023 10:19:06 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.113])
        by smtp.gmail.com with ESMTPSA id j3-20020a17090276c300b001ac7af58b66sm1674083plt.224.2023.06.08.10.19.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2023 10:19:06 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 12/32] arm64: Add support for
 discovering the UART through ACPI
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230530160924.82158-13-nikos.nikoleris@arm.com>
Date:   Thu, 8 Jun 2023 10:18:54 -0700
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com,
        Andrew Jones <drjones@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-13-nikos.nikoleris@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:

>=20
> +static void uart0_init_acpi(void)
> +{
> +	struct spcr_descriptor *spcr =3D =
find_acpi_table_addr(SPCR_SIGNATURE);
> +
> +	assert_msg(spcr, "Unable to find ACPI SPCR");
> +	uart0_base =3D ioremap(spcr->serial_port.address, =
spcr->serial_port.bit_width);
> +}

Is it possible as a fallback, is SPCR is not available, to =
UART_EARLY_BASE as
address and bit_width as bit-width?

I would appreciate it, since it would help my setup.

