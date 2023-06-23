Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCF573B9DF
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 16:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjFWOUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 10:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjFWOUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 10:20:04 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ADD2706
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 07:19:52 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-66872889417so309573b3a.1
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 07:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687529989; x=1690121989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=35x5qxpF2qYzGzCpux1ZzZA29nJCgxRSAHhMlpTtq74=;
        b=c7/Mv2GzBTpMxlDln0Sehv1yTcEaixA7RDWInHiPZ8qzW5GwvkY/zKAM7l7Bc5vDa8
         hDiFsq15Wz2zFUFoWtMfbXwsDd+vrOCwF/cIATp2OnTxIWzNoiK1jlSLbZVmHoOJ/7vi
         OtBiuJJHOg6JoG8ZxlgkpXlZBpIiJhY/YJGFV2qXDPrJLU+IWCPtRpy57oHrGEEDOcKn
         xd3GkNzPA2glBPTifd2TCXN5VbnQHPhVgK1nErqSMqmhAtT4wyvlGXk/rUXCRzL4NpKi
         YKy3w1gtkYRYg6lV+4yPvCa1l/AcBUdWnT/SSIYObqH/VnQIpYYLGhOFLWHg/Y23A5QZ
         APtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687529989; x=1690121989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=35x5qxpF2qYzGzCpux1ZzZA29nJCgxRSAHhMlpTtq74=;
        b=XQkeri/sEIlygsSsiEgHzyvJMqWbSVKs3RBKPXZap/0kx4OVMP1F62Usgj47zpF4hd
         flHdBDKmDFxp7P3oZhAtLRJC0xwYu1tfnqmKBFy3x+MSqxgTEufSbnLNLAzGoXlXFJQg
         Fg1D87aqCsrtWDCvD1zNl+HCuGigybI665sD6STR4sNT+gE+x7DAyRuW/ovmzztYEwbs
         zdEGptamntQJBeDM/rn7ONVwQxi/C6TMy/lYDTALAGxEk/03M3W0FIrSbyRq5QvLugop
         s/zJnBG8aNjIEWcLr7Gl9Wq+KMgQenWcKp8q/wEv+CMPVbrqM4ap31z/V6o+L+SN/D3k
         DrPw==
X-Gm-Message-State: AC+VfDz4zOsubTkNiwBClJY0Ki7tWwtKIfDYxTDHnTFFmqLQ9nQr9YWs
        M0xFiZCJO7t1avNcqNtRn9KxCbzm4do=
X-Google-Smtp-Source: ACHHUZ63ia2UvaYfKaS8EqRcM930UL0opAkoHqHzypa37S+4ovmakcGgORyiJsCL5P1ICG+FKohhXfPKvgE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:811:b0:668:6887:18d with SMTP id
 m17-20020a056a00081100b006686887018dmr5332115pfk.6.1687529989678; Fri, 23 Jun
 2023 07:19:49 -0700 (PDT)
Date:   Fri, 23 Jun 2023 07:19:48 -0700
In-Reply-To: <6c5d1e74-0f6d-7c9d-c4e7-a42342ca60aa@amd.com>
Mime-Version: 1.0
References: <20230615063757.3039121-1-aik@amd.com> <a209f165-b9ae-a0b3-743c-9711f5123855@amd.com>
 <6c5d1e74-0f6d-7c9d-c4e7-a42342ca60aa@amd.com>
Message-ID: <ZJWqBO6mPTWyMgMj@google.com>
Subject: Re: [PATCH kernel 0/9 v6] KVM: SEV: Enable AMD SEV-ES DebugSwap
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023, Alexey Kardashevskiy wrote:
> Sean, do you want me to repost with "v6" in all patches or this will do?

No need on my end.
