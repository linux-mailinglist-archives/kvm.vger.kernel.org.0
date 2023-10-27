Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9E17D941A
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 11:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbjJ0Jqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 05:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345671AbjJ0Jqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 05:46:53 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0C19D
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:46:51 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-32d9effe314so1284040f8f.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698400009; x=1699004809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jzLwa1GntXahp5+i4Iu7OMe0oRp7S0Pb5ddkQlqpbTs=;
        b=V1sgpg7pDhvz8H+KGDrcSzxSO2igQbcjlEX3jIAjvp01p9LN1OJOvaJ/nyR6GqUuyg
         NZmLPKRxhV4kGQYbU+kTmdITerjO5BDl/RZbxNrSkCFlLFfu5XpWuw3yLfz7IPz8Ahfw
         b4srtWknAzHRJfG6u0rE42hCDefKdAjDujKQfdI+S8isLBM4WCnHzFYiNGim9lonVPJa
         wD6RHFEb34nkLbzmpflQffvPnCtppne1Ival0dzrWDbB63hsOwdeXCf+VN0FJOHYRNuG
         9/pdMma/gNJ29GNPeApEvIJrDwexTufxANc6DzfkkDkgud+9rZEOxAvbbTgTeFsQKXMT
         uwog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698400009; x=1699004809;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jzLwa1GntXahp5+i4Iu7OMe0oRp7S0Pb5ddkQlqpbTs=;
        b=Y9AZKuP3DYk85yLcojT1XvzzP+/jogY8EW09b7gWt/qfOCRKSM0W5ARKH/LlqwOh9Y
         Y57MP+wqd6UZGgBb7KPxmKO5Ldj/Yb2Aokn3/nJYIXXBK6C9dumJruHGEl/4l3sPXSBm
         qe1AOl/nQOlbET0QEeO56g+njEQN133rhbW16tIfTnNqXabHugaLvCfNc/dVjh4rUX0G
         NEQfiMfCNLNa96IUkJD6lElIW5jxp2ugrvlJlFEMsEtlfkqX5M95jZjqm34RT9qUvHHz
         wLuvI1lbQnX4Xc6SC+JmihQ6Gk0qstjUk1XElt20U360kLYkt0GjLg5sleTcm4fTN/Pp
         /ACQ==
X-Gm-Message-State: AOJu0Yx8vabdyhoL5HUpMFah0NLZVy2gOnms066amO6zg5/h10Xtb1of
        p4QH1tplKpWovgt8HA73Tp0=
X-Google-Smtp-Source: AGHT+IF+xd8cuMtFJ/cywAMdwJALH04PvtMGn/mtI5e9KZNkVRA1ttigVPEIA2v+rqX3cz0pRpds5w==
X-Received: by 2002:a5d:68c1:0:b0:32d:a022:8559 with SMTP id p1-20020a5d68c1000000b0032da0228559mr1762750wrw.47.1698400009412;
        Fri, 27 Oct 2023 02:46:49 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id e9-20020a5d5949000000b00326f5d0ce0asm1389222wri.21.2023.10.27.02.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 02:46:49 -0700 (PDT)
Message-ID: <b6cb24e3-d736-4951-b2dd-2a90562fd768@gmail.com>
Date:   Fri, 27 Oct 2023 10:46:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 25/28] hw/pci: add pci_init_nic_devices(),
 pci_init_nic_in_slot()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231025145042.627381-1-dwmw2@infradead.org>
 <20231025145042.627381-26-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-26-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The loop over nd_table[] to add PCI NICs is repeated in quite a few
> places. Add a helper function to do it.
> 
> Some platforms also try to instantiate a specific model in a specific
> slot, to match the real hardware. Add pci_init_nic_in_slot() for that
> purpose.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/pci/pci.c         | 45 ++++++++++++++++++++++++++++++++++++++++++++
>   include/hw/pci/pci.h |  4 +++-
>   2 files changed, 48 insertions(+), 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

