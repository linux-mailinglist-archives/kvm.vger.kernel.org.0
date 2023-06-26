Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E6B73EB34
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 21:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjFZT12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 15:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjFZT11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 15:27:27 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD4CE74
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 12:27:25 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so5062475e87.2
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 12:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687807643; x=1690399643;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wmS0RRWycn4EuJuc2Hvx1IYIdP4P9fMYilsTOwEvO4=;
        b=QO/ssB0jHOcla4XUYJBG+dy9i8+JuoAiQiPSv0QTJURucx9ssdfefiWMljDCPrDhJN
         u2WUkGg1D0pmwmI56ku1YXXOEp7UX7i7Y2U3ofDJp8BwsX8EVkBpiLu3l75rJr7zLKvm
         FzwPaK/mFRWwulepjK0V4TJHKhfszhyQC333AF7YnvWig+trz5UxjEGJYDFyuR4Isv+E
         xKU7rZaoR30nOQ5LzNcf6dwirD4mK6lRFu33tel5lSfiv0ObIoNhdjHIFGr9NBljexHb
         kNqoVDPiSLCE9WdTtjGy6W/1EGoSvZSeEHJsF49UmbUKeiiPwgWu0YE6yQBep2suS6XO
         XUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687807643; x=1690399643;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6wmS0RRWycn4EuJuc2Hvx1IYIdP4P9fMYilsTOwEvO4=;
        b=dHufj5NgYTWwACDu1pueoXRwtqD4oRsGUMkMC9sVKywL2BEb3U2gTmii5My/nxWWgX
         GilZwxwuDuCOb5c4qLmc/2G7CXtD0J5pg3RXuXbZZB7Fb378z3MDtUKYxC+Md4nq6ZLd
         yk/9G3+Tojjw6mjc8IcylW3rKzeQbTk1054cWifhv3xYuSHY22noNMzh0qSORT8Gzy44
         kQ1K3XqtxJO1C5EUBowxH++bzzEptuFF7X6BzU3w7fGLlZPYKV20Pzm0wXtMknaWLkF4
         wfzVUaicuTu+BAAzHsa8vZS66mrPek97zG3bUFFeQctiZig7tewjqgVPFqslxC/ZkF7t
         1lMw==
X-Gm-Message-State: AC+VfDxuAc6lkK+fPcYV8/WHDDDV7nONBIi5Wnkru2zRtEBHWW0aC5gr
        SSLR0/fLYF9ydve4rRH+Lg0ivUuBu0o=
X-Google-Smtp-Source: ACHHUZ7smBLgbIVXj6vWIYi135RlITCmat9aFrzXxpe+alPWkxn/LSAjYrWfBAxfyIIfmvNO+D+gJw==
X-Received: by 2002:ac2:4f12:0:b0:4ed:cc6d:61fe with SMTP id k18-20020ac24f12000000b004edcc6d61femr2758547lfr.24.1687807643358;
        Mon, 26 Jun 2023 12:27:23 -0700 (PDT)
Received: from [192.168.3.4] (84-10-243-27.static.chello.pl. [84.10.243.27])
        by smtp.gmail.com with ESMTPSA id u15-20020a056512040f00b004faa2de9877sm998801lfk.286.2023.06.26.12.27.22
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jun 2023 12:27:22 -0700 (PDT)
Message-ID: <27d70475-ce93-fccb-2ec3-94ca8b9dddcd@gmail.com>
Date:   Mon, 26 Jun 2023 21:27:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     kvm@vger.kernel.org
From:   =?UTF-8?Q?=c5=81ukasz_Kalam=c5=82acki?= <kalamlacki@gmail.com>
Subject: Virtual Machine Manager issue on Kernel 6.4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,


I have just compiled Linux Kernel 6.4 and tried to run Virtual Machine 
Manager (4.1.0) but on 6.4 it does not ask me for password during 
connection attempt and VMM cannot connect to libvirtd which is up and 
running on Debian. This works well on Kernel 6.3.9. Do I need to update 
something for Kernel 6.4?


Best regards,

Łukasz

