Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBF57D8F95
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 09:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345404AbjJ0HUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 03:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345449AbjJ0HUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 03:20:25 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B7F1B4
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:20:23 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-32ded3eb835so1290555f8f.0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698391221; x=1698996021; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GiaZXgzc6McjQsGUPYikXLbeJ+i8MopBoPjQmhJQfo4=;
        b=Z5xcV4kIjn0BHHzwj4vbiC8lSk+Yb+DCWLPek85pELtbHSdCrtyT0lUYnBvw0VSAha
         xjelaCdbvFlnrKN1sR2eLvgBG5oco5MVmd+yinweZ2ABO/jc+JpmzGjIBFD1WJeSIAhi
         6LT3O0sfUEVNYqnJbp0lYNc4mEy8AlpB1xt4VIEmNeJICZc+CGmVz/Nr7Dq9LpLfH8PU
         KSUpA6yCphRxDZPEwZCX+ioxUxHz20ELb/kf9tHvO6mwnjVgt1U5OvFS8dElVRYt6dWS
         AX7Gl/O6rvvoSouz90fLPwGrEw02LdIpMPOmCf5xvodeqrg8F3Bss6578dD/89k/eAY2
         PO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698391221; x=1698996021;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GiaZXgzc6McjQsGUPYikXLbeJ+i8MopBoPjQmhJQfo4=;
        b=cdKxoQDgCumj8ooOjntNkzKh37oAuxGHZ8vbSJlVBleRLgdljoUmyuwveQ5jTM8Tez
         lcvn6zOCyxf+hxRvwWGKyW5WgK8TVWWzVzSZ2NMJB01RJXJmhY1+BFlAfqpnc//vnnL5
         LWXfoD9oor4GQ88oJW6C8xb4plDYhtI89G+4AkjN1NbhYFmD00ru6uJ9tAU0MOw2+YsD
         GG2nqWV+R7w/6CObHHu9IDklhuNDvAY9MRkhq7Lzy0EvY0R9h7CGgS2B4B9YLcn0W4Co
         vRCUa2TtuzXEnINfrqdAM7Jxng8NCYnSQXPjXFr5bLgXfX3hy8MEZQByaJ1Zulz0LnL4
         jPRA==
X-Gm-Message-State: AOJu0YxMfrK3raL6aKAqe3NgcULwlNft45tgGIoPpaDM0/0bUB2FNYgT
        vrwpNpnDlpbq1NiXkKTaFJc=
X-Google-Smtp-Source: AGHT+IF4ESb9Dtm5knfUhlBl2xjFSwSZ+UZKmlwz+qng/KTBk8Cd66OauspRUmQDrVkZd9/qUpk6wg==
X-Received: by 2002:a5d:4c42:0:b0:31f:a62d:264 with SMTP id n2-20020a5d4c42000000b0031fa62d0264mr1433744wrt.37.1698391221555;
        Fri, 27 Oct 2023 00:20:21 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-227.amazon.com. [54.240.197.227])
        by smtp.gmail.com with ESMTPSA id t13-20020a5d534d000000b0032d9548240fsm1114969wrv.82.2023.10.27.00.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 00:20:21 -0700 (PDT)
Message-ID: <94b54185-7ae6-48f9-976c-f4213a3643d0@gmail.com>
Date:   Fri, 27 Oct 2023 08:20:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 06/28] hw/xen: take iothread mutex in
 xen_evtchn_reset_op()
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
 <20231025145042.627381-7-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-7-dwmw2@infradead.org>
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
> The xen_evtchn_soft_reset() function requires the iothread mutex, but is
> also called for the EVTCHNOP_reset hypercall. Ensure the mutex is taken
> in that case.
> 
> Fixes: a15b10978fe6 ("hw/xen: Implement EVTCHNOP_reset")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/kvm/xen_evtchn.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

