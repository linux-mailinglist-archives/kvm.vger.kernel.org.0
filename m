Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1DE7263F3
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 17:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbjFGPRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 11:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbjFGPRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 11:17:24 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B034F1720
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 08:17:21 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f732d37d7bso36308535e9.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 08:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686151040; x=1688743040;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Y2BdOp4zFOQRlkJfYQouf/KUEf6CShaaPXp4nhhGB8=;
        b=K2qU49+HJMJrmU5H4Sb1XicsBmFDlLUMA8EmS93CPOtL3jnnl4+rO4La8Yv3V6S20i
         qvODLafoaBG8CsCdnQ9QQ/QgGtnkijFEXOwo79lWXHR2MYHs2h5h7t+BsDlln5aZ70WJ
         w8Gulbi03Hr0AQFbuprcZ5D+XGGHiAEpCWyt3BwoAJSf4H6F/ZcRAdkj3nJcrOsU6r1+
         Svae1fNU+pCax3tztTTz1XnDAAifiK1GFqvX1rARL1Bdw5xzbA/tPnA9UXs+SjElCSPs
         WPtd6GrOaPtDiIcVJDioMQsNTxDIqpl9ZmfyF2PSC0QetalzEH/8CdpVFAVrZOVJcvnq
         rL6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151040; x=1688743040;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Y2BdOp4zFOQRlkJfYQouf/KUEf6CShaaPXp4nhhGB8=;
        b=dNz5ht79NDDpzX4iIyN6pWYlvrhD7NpZRUmWUweqYq7izF3+BQHe6KwqoKyW/Y/1jN
         A5ioZmLQgqonF5QtrTBmyFFB8seDLBILiQKI9UH9RipZCyEI9YvDn1zpfkkvWU+gsmG7
         YST5zJX8nvUFEcIJF3nljK+IwRLichq6NbkHlS0ZOf+zXKG3qcjmoJmRDlWcx1PKZNtd
         IbbPh5/CLBbJ3Gv6+ZUZ7/t7//RHCzNxeizBFp7a+Y94jf4Sk6aiq7BNozAIUKOkYicX
         ilJvIzOVswoxxcj9pqb4ld37G60guI5FMi3wsDZAZCoJOgRNeutWH3oETs9Zmweh6WOS
         8SUw==
X-Gm-Message-State: AC+VfDzG/rvOjLHWJASikaPdZTAK9rgJ9tU9ubreKhkdO8dB50sNw6Oy
        Ou4Fv7OdXlio/Rj1/PgD6z6gQw==
X-Google-Smtp-Source: ACHHUZ5cFnNGna0073tkDHVILRhJH396LtzVkR4U/T8iZuHBG5TwwXWoL2v8nNA61ktk+JkmS6IRiw==
X-Received: by 2002:a05:6000:d1:b0:30e:46c3:a179 with SMTP id q17-20020a05600000d100b0030e46c3a179mr4788635wrx.30.1686151040098;
        Wed, 07 Jun 2023 08:17:20 -0700 (PDT)
Received: from [192.168.69.115] (bd137-h02-176-184-46-52.dsl.sta.abo.bbox.fr. [176.184.46.52])
        by smtp.gmail.com with ESMTPSA id n8-20020a5d4c48000000b00301a351a8d6sm15694492wrt.84.2023.06.07.08.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 08:17:19 -0700 (PDT)
Message-ID: <673a858e-8437-24e0-1ca5-3a2f956bb42c@linaro.org>
Date:   Wed, 7 Jun 2023 17:17:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: QEMU developers fortnightly conference call for 2023-06-13
Content-Language: en-US
To:     juan.quintela@gmail.com, afaerber@suse.de, ale@rev.ng, anjo@rev.ng,
        bazulay@redhat.com, bbauman@redhat.com,
        chao.p.peng@linux.intel.com, cjia@nvidia.com, cw@f00f.org,
        david.edmondson@oracle.com, dustin.kirkland@canonical.com,
        eblake@redhat.com, edgar.iglesias@gmail.com,
        elena.ufimtseva@oracle.com, eric.auger@redhat.com, f4bug@amsat.org,
        Felipe Franciosi <felipe.franciosi@nutanix.com>,
        "iggy@theiggy.com" <iggy@kws1.com>, Warner Losh <wlosh@bsdimp.com>,
        jan.kiszka@web.de, jgg@nvidia.com, jidong.xiao@gmail.com,
        jjherne@linux.vnet.ibm.com, joao.m.martins@oracle.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        mburton@qti.qualcomm.com, mdean@redhat.com,
        mimu@linux.vnet.ibm.com, peter.maydell@linaro.org,
        qemu-devel@nongnu.org, quintela@redhat.com,
        richard.henderson@linaro.org, shameerali.kolothum.thodi@huawei.com,
        stefanha@gmail.com, wei.w.wang@intel.com, z.huo@139.com,
        zwu.kernel@gmail.com
References: <calendar-123b3e98-a357-4d85-ac0b-ecce92087a35@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <calendar-123b3e98-a357-4d85-ac0b-ecce92087a35@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Juan,

On 7/6/23 15:55, juan.quintela@gmail.com wrote:
> QEMU developers fortnightly conference call
> 
> Hi
> Here is the wiki for whover that wants to add topics to the agenda.
> https://wiki.qemu.org/QEMUCall#Call_for_agenda_for_2023-06-13 
> <https://wiki.qemu.org/QEMUCall#Call_for_agenda_for_2023-06-13>
> 
> We already have a topic that is "Live Update", so please join.
> 
> Later, Juan.

KVM Forum 2023 is on Wed 14 and Thu 15, so we can expect people
interested to assist being traveling on Tue 13.

There will be Birds of a Feather sessions on Wed 14 from 15:45
to 17:45 (Europe/Prague), perhaps this is a better replacement
(assuming someone from each session volunteer to stream for
remote audience).

Regards,

Phil.

