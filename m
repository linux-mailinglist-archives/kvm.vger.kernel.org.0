Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808D64DDB3F
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 15:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbiCROIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 10:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbiCROIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 10:08:41 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0841B55231
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 07:07:21 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q11so7014613pln.11
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 07:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0q1HcjYUqnmyItc5DrqiMrG7Yl1LzJEhHDG1dkuS69Y=;
        b=RlHIJLDFeG4TkmZesMDCshKfOUZF+9NhD6xPMrH8gZmP9B6KErriPsctYstMztOMRW
         yxwulMzzpWhc1+WbRmj3dqnU7kGCPfzO1SC8BSlOvWBgcMjNwVQq3rB6hk0pkUvI/h/e
         TDzI1T6ZKb7pcmBz0a0kr3WxPsndnXPzb8Q/SRtR6m6kIi+qHV8n6EsWIPnQ43joz5z2
         WYIAWbmNJyLQrysS+OpQyhq0qB+rFsetX9J7hHE1FKsGGuJX/05EQzI48P9MZdQgjMfw
         7Kn/kvyFMKOBUA8NN9VPkRxqrSWAdeAdtW2qB1nlNEqez/gx90QsANhXffkc0wGG9eUr
         hKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0q1HcjYUqnmyItc5DrqiMrG7Yl1LzJEhHDG1dkuS69Y=;
        b=hb43zjcZ07cTvnW7UttKDJh0PuwFxgfGX23NBfgc1Aptou1pNvum9Ut+O6RYEW2Zvw
         MSNjzghTXu3WZ595SFJhujyggdTebtlPsgvnPGJN1/CbU3BfK1X10zCSBTkBkMgS2eyW
         GOulfBZjOHeN8mvhZWJdPAMVkq0KlBiCwcoeYzLLAC1ut4rzWTpOxxAOkBs8vDvjU5nI
         KUBPYgJwVRgKv5vQ8LEFnEemJ9As5oDsXY/L6MMW3inzJ4FuPl6bHA6ZDGk6bzQkfniu
         FIhDbW6TUkpZ6maYTEtF514DO8J/zXG5+t+P6Ht9NJEsuT6FplUhSioJFJR0bngab115
         GpiQ==
X-Gm-Message-State: AOAM5328wehr2DNXvhaTcCbW4vRk0usOd3fKOF/D55hZXWoFwx8aHP2j
        uu4wnCrpmfT/5mkjNVvjOiE=
X-Google-Smtp-Source: ABdhPJyFumqFEDeamSKRGeSLnoDdZwsKMkNEbaj/svyQoFspLX0+QU4iHJZ76uhYoIPSem5LDv3alw==
X-Received: by 2002:a17:902:a3ca:b0:14f:d48e:aff3 with SMTP id q10-20020a170902a3ca00b0014fd48eaff3mr10148558plb.167.1647612440411;
        Fri, 18 Mar 2022 07:07:20 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id c11-20020a056a000acb00b004f35ee129bbsm10654221pfl.140.2022.03.18.07.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 07:07:20 -0700 (PDT)
Message-ID: <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
Date:   Fri, 18 Mar 2022 15:07:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-18-xiaoyao.li@intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>
In-Reply-To: <20220317135913.2166202-18-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 17/3/22 14:58, Xiaoyao Li wrote:
> TDX VM needs to boot with Trust Domain Virtual Firmware (TDVF). Unlike
> that OVMF is mapped as rom device, TDVF needs to be mapped as private
> memory. This is because TDX architecture doesn't provide read-only
> capability for VMM, and it doesn't support instruction emulation due
> to guest memory and registers are not accessible for VMM.
> 
> On the other hand, OVMF can work as TDVF, which is usually configured
> as pflash device in QEMU. To keep the same usage (QEMU parameter),
> introduce ram_mode to pflash for TDVF. When it's creating a TDX VM,
> ram_mode will be enabled automatically that map the firmware as RAM.
> 
> Note, this implies two things:
>   1. TDVF (OVMF) is not read-only (write-protected).
> 
>   2. It doesn't support non-volatile UEFI variables as what pflash
>      supports that the change to non-volatile UEFI variables won't get
>      synced back to backend vars.fd file.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   hw/block/pflash_cfi01.c | 25 ++++++++++++++++++-------
>   hw/i386/pc_sysfw.c      | 14 +++++++++++---
>   2 files changed, 29 insertions(+), 10 deletions(-)

If you don't need a pflash device, don't use it: simply map your nvram
region as ram in your machine. No need to clutter the pflash model like
that.

NAcked-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

