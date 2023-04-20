Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B966E9B4E
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 20:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjDTSKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 14:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjDTSKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 14:10:13 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3448344BE
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 11:10:09 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f17b967bfbso25661665e9.1
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 11:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682014207; x=1684606207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3tTimXPUFA+X0/aMlpW0bIFSfqQCXvrIyP+TzAV0QAo=;
        b=J/1WiSoVaU2DeuE5CeLf4PUd0lFh1qEauGbEPR7HSYPZP3YI3ew9bTozKNbfEOZlW7
         ba3rr35yW6hfetch9hQM3LPdo4yiWkc7dkvam5YpaaBhCf9fM68Jwmyost89XkXZG/j4
         AyIOFhcWask2UqKAd2+aubHZ7VAUhSmXen18eXlFriSsccEqG+Tw3zN1avvUjF3RSgmv
         3A5pKA3I2qREx2N2gAPFJ86R6MsvozfFglYg8e9KO/5ptyQZkQQSdAQOVaY5T9hM93pW
         +bOz0Ypt9PoASs0/GtmuSQWBqv6gPNfJJWNeaHWQGcLItdyZWpKshWLX5g/swUCT0Qmb
         mWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682014207; x=1684606207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3tTimXPUFA+X0/aMlpW0bIFSfqQCXvrIyP+TzAV0QAo=;
        b=K6EP8PY4gZ47M3NeShUfNq1OgbQD8N/OwHOctPW6KrtUkMRN9/s98RsbzQ4bGZHuO/
         Cz6DTbTqBDWOkbSORSRiSF8kXBNXH6tJht63OtfBfLNP/Fa4dSbsfTJhCm1O6A32uSco
         /ose9LXv3I8wNZ/agffq0+qJr5KDlCcp7DSlI6O1EO5HeZ5BI9BwhJOtSD3Y4shuRgj3
         Xgm/adpTuppKgIbZtQJJu7LKtKRpA6Gl4mW8UUrCusunP5y8os6LqbzSPkdSNr3CTg2B
         uRJIc7Kd9tWm9j1+HUmf1A+XRZujj8qKq8dW3KShHdUOfkoUSET+eUeJ2tNy0rS5OWIo
         WhXA==
X-Gm-Message-State: AAQBX9dWmr787KJkk5pFYDJldFLos5Bhv/LFJlXjNzk/yyQ5NnL5Oxot
        3pgPOtBE6511bGSxgdolVhdw+cgdkxzfm0NRDHSPlw==
X-Google-Smtp-Source: AKy350YKmxmoghfij+pf32r0TBd/PBCk7J+ihUx7vhnJEGhBVYhIkPHhwvgFKI4Fv9Wnde3u6LgsgQHuzVzSB7fXiiM=
X-Received: by 2002:adf:f3cd:0:b0:2f5:9146:7024 with SMTP id
 g13-20020adff3cd000000b002f591467024mr5898472wrp.22.1682014207340; Thu, 20
 Apr 2023 11:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-6-amoorthy@google.com>
 <a518e669-c758-57c8-3ba9-b4844e2cb79d@gmail.com>
In-Reply-To: <a518e669-c758-57c8-3ba9-b4844e2cb79d@gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 20 Apr 2023 11:09:30 -0700
Message-ID: <CAF7b7mopmS5dQEQSC4g5NVmDpfV7UJv2UursruROrr3kb=BQHQ@mail.gmail.com>
Subject: Re: [PATCH v3 05/22] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Hoo Robert <robert.hoo.linux@gmail.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023 at 6:57=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
>
> kvm_populate_efault_info(), function name.
> ...
> Ditto

Done

> struct exit_reason[] string for KVM_EXIT_MEMORY_FAULT can be added as
> well.

Done, assuming you mean the exit_reasons_known definition in kvm_util.c
