Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD5E4BA777
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 18:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbiBQRuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 12:50:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiBQRuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 12:50:00 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC79291FB8
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:49:45 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id qx21so9006894ejb.13
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U77EXb6P2PtDodk5/5hyfXkd24Ya40Da3QojNfYunrw=;
        b=YGzMBRKrNxMZWXwKhwPndObfL6uz2mVs+GS+AmhLTReAHVJThRycO3+J2ymoCV3ziw
         weL2Xu0OviFQdsgYnBzk7IiTB3wGXYiJpr3r6xFzJzI5P34RM1MtWCtIgg4SLT3AtfCs
         1hP8cEHnXFLItmw2eYJPQo2j9EfRttmrctuMf5rS/3nbOLNDEOXRPNoEjKA84VVtqXLJ
         n5A7taHrhhifWbKv2hDc66tBc3DLz0OG+RFEWY4W4HxgS7JVHUWiwQGq5gTb52w4n1oL
         EpRZCjGW50A/tSpxEof3CRgw99fhBzIWLvuDDVYxKVfheVsGbOTH1zu8IVwLE4U4JLlb
         y14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U77EXb6P2PtDodk5/5hyfXkd24Ya40Da3QojNfYunrw=;
        b=HW24Xy0iMkFN71XroCI6E6JixO8NX7gl+FQBfAo8OIsqvE5cdd3YoNBYhThmzZbsPr
         vFUHywP14tE1fBuASJq5Y3L7WxnDfQez3tSLFPy/Y1ZIbKKZXHmyAL+jN02B5lv5EHF0
         bPUY/nQ1Ar/V37fBoEC662Bd1G0LjwRpRGbotzUxHk7MSGQDG30Df423i8XAkspCKCAm
         gd+f3v1tDW3zUG5TURDPPO6qUUrfnly+32bPjMy4aeBLSdTaiQq0CQiR30Cl6sWFcZ7r
         K8mANaUVgdXawdHIuIwvQThpJ4doiKrkonkbjULKIPxD70hmy3Cr7YBkXc4YOW7+sUmq
         mREw==
X-Gm-Message-State: AOAM532/vOvPpsUQmM+EtkAqe7kPMm6n+XdEGPg604A1AcuXLwBBbveW
        bZ9J+7TNK2Xf3t+ntWqJ6XM=
X-Google-Smtp-Source: ABdhPJyzry0GzvmLnbxW8zBbfXHv2gdbIhYSWS/devZZZeKhhu+4F7eTOSTM7IGINwIE0Dp6TIkvVw==
X-Received: by 2002:a17:906:1e13:b0:6ce:e50c:2a9c with SMTP id g19-20020a1709061e1300b006cee50c2a9cmr3198839ejj.546.1645120184451;
        Thu, 17 Feb 2022 09:49:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m11sm3754607edc.110.2022.02.17.09.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 09:49:44 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <70c04ba7-d617-580d-deaa-97018192e8a6@redhat.com>
Date:   Thu, 17 Feb 2022 18:49:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@gmail.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sergio Lopez <slp@redhat.com>, kvm <kvm@vger.kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        John Snow <jsnow@redhat.com>, Hannes Reinecke <hare@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alex Agache <aagch@amazon.com>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com>
 <CAJSP0QX6JgCG7UdqaY=G8rc64ZqE912UzM7pQkSMBfzGywHaHg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAJSP0QX6JgCG7UdqaY=G8rc64ZqE912UzM7pQkSMBfzGywHaHg@mail.gmail.com>
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

On 2/14/22 15:01, Stefan Hajnoczi wrote:
> Thanks for this idea. As a stretch goal we could add implementing the
> packed virtqueue layout in Linux vhost, QEMU's libvhost-user, and/or
> QEMU's virtio qtest code.

Why not have a separate project for packed virtqueue layout?

Paolo
