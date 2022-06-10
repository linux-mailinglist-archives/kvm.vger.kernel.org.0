Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC94545909
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 02:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbiFJAOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 20:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiFJAOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 20:14:33 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B063280B1F
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 17:14:32 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g186so14419959pgc.1
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 17:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5ZpICK2s04+dMtDaxHdX9/pjuoOJWneKfeE8NGKcaY0=;
        b=l9o+WnImMyYUEacgUO29oijJhkwXuCtjdze61yEpxNqyqkwEyfMhsqwtizEgPudEDk
         c92hO/+MnixUKLVmYn+nAv2h3vK5tMTyrqb6cGX33FJblnha1pmpFUCO1XzNpmo2nlKz
         18oh60v+N1dPExEGVzW65W6Nhxyr9mh2JUrfhFyx9nh8+GoKEGWcGI8phO4rM4v2fLAD
         iQbJnPAe2MQMJvMbXhJGmJZoPFpnvsytJuXIwNaSoyXBSY+5/xUXmljxzhXSk0UiwAYM
         H3+xb5WNti9zIWvWAivyFt/nL40sd91BXz+5kpKXAOCVu6bzKVPvFuZuvls+/KRRbPj/
         h0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5ZpICK2s04+dMtDaxHdX9/pjuoOJWneKfeE8NGKcaY0=;
        b=zJ22AePzuTQ58bDNgMMkzgVsndIWws6jOcUWO6+S7Hpbjjg0Fb6tbJEvj4UmXe1VY+
         7ZBP9SYoKUIFRuI/o67LbCnMGQV1nhHYwFDjKgth5hY9LjFbBrIl1E1tsWrvYrEV4WpO
         2f5gznBRF5fpPpEgsbSh4IY9n1ywKN4qLH3r/i/b1vq2oO/Qn4jjJhc2sBUbr8AoRroQ
         u5MAVgzsrJ8VpiyMAJIm0BzM7QXf9/7u1/oWAo8kxeaMJLr06UJbfZpMBdmE0lJBPMhU
         0Ux1RoyER5wkc9IRoh9e0li8NeAwh41vSwZWqutfm5nY795q6IuU2kP358lz4a5X5CHN
         7+Vg==
X-Gm-Message-State: AOAM531LLeMIXxWt3ed6rISAQJrlGQEtjdyveX8rPVsosFj/GZKLhSZg
        w5ips1h2PpvULKqFyW6g9sPnluGbHvI=
X-Google-Smtp-Source: ABdhPJwGxHFpHyc6M363MnJHSXMw6w4Ray5hjxq0LqjCgMsm1WGXrIEVMLGG5UNX3zLL2/lVrOb0FQ==
X-Received: by 2002:a05:6a00:1482:b0:51c:6134:de1a with SMTP id v2-20020a056a00148200b0051c6134de1amr12219241pfu.31.1654820071655;
        Thu, 09 Jun 2022 17:14:31 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.22])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902ea4a00b00163e459be9asm10439161plg.136.2022.06.09.17.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 17:14:31 -0700 (PDT)
Message-ID: <587f8bc5-76fc-6cd7-d3d7-3a712c3f1274@gmail.com>
Date:   Fri, 10 Jun 2022 08:14:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Skip perf related tests when pmu
 is disabled
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <20220609083916.36658-4-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220609083916.36658-4-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/6/2022 4:39 pm, Yang Weijiang wrote:
> executing rdpmc leads to #GP,

RDPMC still works on processors that do not support architectural performance 
monitoring.

The #GP will violate ISA, and try to treat it as NOP (plus EAX=EDX=0) if 
!enable_pmu.
