Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5923C28F9
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 20:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhGIS1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 14:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhGIS1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 14:27:43 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86823C0613DD
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 11:24:59 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so10378553otl.3
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 11:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cCbbGBdIPrXvg7z6uGOacux3U5ndYtQkeQddrGJuteo=;
        b=vlf7whsxzmtk448E1+o9NJ2OOvxq8TJ2U1w08A420zMEZs6W2ipS2fhv+6aIUud8KN
         vkxYEtg6M0DPKVILq6QVBoe5bpMUSWtDExRVJ3yCcTsBBTgNvkTAHyMQE56ubhz7MMEF
         YJQITWDNSlAYqbmyEjYYbP90n1EGex9kwB7b4hGTuFxHhmLuquQpw6D+kS/I8uWtZT32
         QW3fPnVhkFu7uiq+3Rm92d9wrOv37IVqpWAw5eHbAl8r+ktQZoh4b/k2zzdF7/BHJPrz
         0XfW/RX2l3n9V8B9WN/HuTHquPbwqp3vbOze3EUq7ok7bj1brfF3h2xq9blXQOlznpMf
         +tGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cCbbGBdIPrXvg7z6uGOacux3U5ndYtQkeQddrGJuteo=;
        b=e5PN7olSgwSTkiNlHYxItuRMxMBBb+Y6BIGK8F/9KhWdiTZ4EEl/LJrXNi1lJlbRlC
         aGgmqXq5f051laxfA1NoCIJPrwEjYBe+nMMsIHlogmC0EkH8cJHhByGz+eQIhDWSMp6p
         GeQqdt/PrqEzNeoQKg5l1Z9sfPFVBUHVi9NpwlXzLzuPC1nyyVtVJl3etaQJvvNfoeRK
         YPU7+NZAYQIo1SJ6Rugi4n8nx/Y15sfh00alMDIQAIwM4E/WD2UAm1s64YMOLIDW60g4
         Bz6I9H4DuCJ/lLzrJi0Q+2aU4DZhYuZa+v5A2cE3WIPLuHwAsBXKagT4UmkVXO2jR/MR
         O1DQ==
X-Gm-Message-State: AOAM530HkSpBeX2fivRhsFDX381XzP7WbSOyrJ/Lf3G1FQqJqR2OcNEy
        kqwYy+Bp/xir3GsJMmyjzw7at2PxKCgafyiCiSo6gQ==
X-Google-Smtp-Source: ABdhPJwgHvARYc2xotg4epyoFW+Z6WbiX8NYhMBNuPl98PG+uDuX+DhvJJJo51/2+oEuNnMJLuao6yNXhLG9XhXxEYA=
X-Received: by 2002:a05:6830:25cb:: with SMTP id d11mr24052350otu.56.1625855098621;
 Fri, 09 Jul 2021 11:24:58 -0700 (PDT)
MIME-Version: 1.0
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com> <1625825111-6604-4-git-send-email-weijiang.yang@intel.com>
In-Reply-To: <1625825111-6604-4-git-send-email-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 9 Jul 2021 11:24:46 -0700
Message-ID: <CALMp9eTKNG_b6Te=aV_Qd3ADXzf8RkvDhGfWtopQGAf51eHMbg@mail.gmail.com>
Subject: Re: [PATCH v5 03/13] KVM: x86: Add arch LBR MSRs to msrs_to_save_all list
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> Arch LBR MSR_ARCH_LBR_DEPTH and MSR_ARCH_LBR_CTL are {saved|restored}
> by userspace application if they're available.
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
