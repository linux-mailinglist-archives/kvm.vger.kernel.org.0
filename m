Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9046544F20
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 16:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244119AbiFIObl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 10:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243228AbiFIObk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 10:31:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D2E87223B
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 07:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654785098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JsdcbBuqs+9AkFKludyyaoEgkMyebBlGznmKRw5re5A=;
        b=ZQv9y5W49phmr/uxBdWnLAo8rwmj96vNjwbJZCrK/uwTSDq/bKv4D1+cKjOfl6AfyOLq1d
        w3I2a3gFDvI9OV1a3idv0/Y5iTIkYnYv+o1GcvJeQIi2wDM4H/9N2+IO+ncMvBO8in464s
        80hhiMsuQHDf4o+RqPEKJItiluqg5fs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-1Wji5VBqOWG3lLDh9O2O9w-1; Thu, 09 Jun 2022 10:31:37 -0400
X-MC-Unique: 1Wji5VBqOWG3lLDh9O2O9w-1
Received: by mail-ej1-f69.google.com with SMTP id a9-20020a17090682c900b0070b513b9dc4so9329885ejy.4
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 07:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JsdcbBuqs+9AkFKludyyaoEgkMyebBlGznmKRw5re5A=;
        b=yzPjnCvRPZ/28NtVRj7r7mNii4fSsrPrchnpPSAtMyu80CBC9eeibpw4/XWIGr1gZ/
         UCE7rVIPcBW5raCaQYIu3b9zJZ8sWCsgo/jbXtuXYFFYGus4UErSHVyIwBSu1Zt6Uyi2
         zg/Zjfjm1gy1jE633G6yoDDP8GCaYT3ojaAe1pq9yLUC7JmV5rdheW7G+wXD+cInEe6O
         FBYmCtZvX+bGg7b40rR5mmPoQWD+aArQTAUfXMPgkLlscG86g9M/DX6MqsyWexvv20Vi
         ko78mB+4M+An1Kgi74yQJDfkdiCzaWef0Yf4hgxBmtnO5+qdgRPxfuPTNcdSO/8MdlMv
         /PWg==
X-Gm-Message-State: AOAM5311v+tgXOWBQgaOzQp2t/3sf9xvfE+ZDvnVgE9J9APaPPcUiOZp
        bf6W+U0TULTN8xqhZkNKEeyrNXyGHyTBoLZB0VS2RY9MspN3c1G5xpDzv7RThwqWlKV1CNitjHr
        B2Dl+UrgFtWR9
X-Received: by 2002:a17:906:6dc6:b0:70f:ba24:319a with SMTP id j6-20020a1709066dc600b0070fba24319amr28664709ejt.303.1654785095262;
        Thu, 09 Jun 2022 07:31:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoQWLm+/QwRbVkMQvLeFfNQY1YXcHVC2Q1+ORsW9hhSIxCE3zZmy+mhQFlig6o80l7vTPrqA==
X-Received: by 2002:a17:906:6dc6:b0:70f:ba24:319a with SMTP id j6-20020a1709066dc600b0070fba24319amr28664690ejt.303.1654785095043;
        Thu, 09 Jun 2022 07:31:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h4-20020a17090791c400b007109b15c109sm7501397ejz.66.2022.06.09.07.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 07:31:34 -0700 (PDT)
Message-ID: <75a981ef-6a9d-4b14-be03-eca2e7c6110c@redhat.com>
Date:   Thu, 9 Jun 2022 16:31:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: Guest migration between different Ryzen CPU generations
Content-Language: en-US
To:     mike tancsa <mike@sentex.net>, kvm@vger.kernel.org
References: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
 <0fa08623-22c3-d6c6-d068-4582bd8d2424@redhat.com>
 <28563857-e860-ab70-75ba-6cd5b2e1c23a@sentex.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <28563857-e860-ab70-75ba-6cd5b2e1c23a@sentex.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/22 16:08, mike tancsa wrote:
>>
> Thanks for the followup. Forgive the naive question, but I am new to 
> linux. Do patches like this typically get picked up by distributions 
> like Ubuntu, or would I need open a bug report to flag this for them so 
> its included in their updates ?

Yes, they are.

Paolo

