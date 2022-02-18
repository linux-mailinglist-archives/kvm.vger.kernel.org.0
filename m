Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575804BB5DA
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 10:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbiBRJoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 04:44:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbiBRJoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 04:44:07 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471C4237F5;
        Fri, 18 Feb 2022 01:43:51 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id qx21so13588790ejb.13;
        Fri, 18 Feb 2022 01:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8gzRpoadSXSxB0BIzDqVsAXWUfQOc0XeG3vY2OHWrw4=;
        b=XKfx6RWsxF0BE8FESNVpCImccET2T6xMYcSKtsrB0C7zVJBx63CTl5dDyu6HffnIMC
         gG6909iMibiElPgOTMVG2Fy4NGAhwdOWHxVzrY4JHhNi/ezqp28SzsSQwOQf/iqxkaDK
         xUWAtzZdl75P4LhJy9WtWq2Den344zuoVkJHwQEnZxRTP1iAS1A/eh5hhQmi4IjqdabV
         4/bthYoCatA5SfUM/entbQh8OIirTCDXJQdE5yK6ShuioF0HDmKej7MIVeLGVI8saJrp
         0qFrsIwwbubqVQaOoAp+olFiICrwvJHYOI1bX8+EfgxnzaCu9W7nZNvowEusykvXCvHU
         OXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8gzRpoadSXSxB0BIzDqVsAXWUfQOc0XeG3vY2OHWrw4=;
        b=6NfmG//2PbBmOwlJNgfATOR4NC1/Ja+LheIb6sLnShHxxRPjc9uTF8RDmJORJoSdMb
         VB/QMebJvYhaET1kjx/P/iJRoZDQaYO5U0ltf3OWxiEYyKFHRmI5ABEKS/Vdvw4lPim4
         98QXD3JWfOlecWVteYlA/pHI4ruP4cwRBlQ7q0rRUZBHVdGoz50UpHGhHrMVrVh2kMq2
         AxiTSZv1l9G26PpAmj0JU4woKU+4DMBo3NxV0wTD8F6r41FEsdWSGI9sb6+ldyXTTc2x
         rBJgTo3YOZot1UZ/4wDLD7MwMti3MJXtdiqb3Qs8izUiclYuJEendtBjslZdZ2f4jAWZ
         CV9w==
X-Gm-Message-State: AOAM530GdvDH6ioj7wuM3MRjrED225CHgbNZz7O/lgcLmSkbxt3QP9XZ
        JdIR+7hMT+QuDYcflOu9bSNOHiLcJGY=
X-Google-Smtp-Source: ABdhPJy+9t1giFT+NiQvcNipEOFTkMK7WctZSrFXg32Fjh4JpcNBg7jYgNyMstxgvwVGTDCf8KJZ8Q==
X-Received: by 2002:a17:906:c211:b0:6ce:e221:4c21 with SMTP id d17-20020a170906c21100b006cee2214c21mr5610629ejz.691.1645177429712;
        Fri, 18 Feb 2022 01:43:49 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id gq1sm2072372ejb.58.2022.02.18.01.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 01:43:49 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bfe385f9-b075-12e7-43c3-7957bf1b54bc@redhat.com>
Date:   Fri, 18 Feb 2022 10:43:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] KVM: SEV: Allow SEV intra-host migration of VM with
 mirrors
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>, linux-kernel@vger.kernel.org
References: <20220211193634.3183388-1-pgonda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220211193634.3183388-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 20:36, Peter Gonda wrote:
> -	WARN_ON(sev->num_mirrored_vms);
> +	WARN_ON(!list_empty(&sev->mirror_vms));
>   
>   	if (!sev_guest(kvm))
>   		return;
> @@ -2049,11 +2071,9 @@ void sev_vm_destroy(struct kvm *kvm)

Note, the WARN must now be moved after "if (!sev_guest(kvm))" (before, 
num_mirrored_vms was initialized to 0).

Paolo
