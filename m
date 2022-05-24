Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D800C532889
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 13:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbiEXLLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 07:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiEXLKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 07:10:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B96D719D9
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653390650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=27j6k2cZCDZNWXJr0tCIl5JL3x96MfpkYNoEKRGmf48=;
        b=Ui573emDTxI18JMuLN5A4PGpedrKUowggg7bZjzyc0Ct1pK6YCc9k6uEFDR02Jgu4DEA/j
        QyVMVeHUYVRhhi0i+XEkWH/Al/jZkS4W9O555tQpoBpCg9oixPJ+j4B+sbjKJ+eAT98VbN
        hH+t0weXP6dcDIY/mEWif/28m/3T7H0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-KpT3JABOMaWJgt1deUtrAA-1; Tue, 24 May 2022 07:10:49 -0400
X-MC-Unique: KpT3JABOMaWJgt1deUtrAA-1
Received: by mail-wm1-f71.google.com with SMTP id o23-20020a05600c511700b0039743cd8093so1144641wms.6
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:10:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=27j6k2cZCDZNWXJr0tCIl5JL3x96MfpkYNoEKRGmf48=;
        b=NDh1eoGmwGcP+Tdovi7Y09Ernu1d2FcuaWWqysd7gz/G/Iorh5rI0yVf/S2nNvra7+
         iVBSHGspBA+b52N24HiQYBHAfwQMLZcx2l8kxoBU+23J62vALlceMFpxeyrKoCSwI+wH
         qt+jXdD8SkEhi3ru1CAEeS5epWfEo/XrBOAYHw/SXgu5vjXMVkP3+hX6I7EjU68yJVg9
         EVG1Sr46xXwlf0jAn91CGcsNwa8tmJfd+5zmJvys4wxVwVxFJjnx7BBE2QOTqF3nF2av
         w2ekVworklQwj1e7qTHtUqBC+aUV5hPjzFS6P2wAKTRWcxmHcpTiXPuxxiZLPXA9JEGG
         ov+w==
X-Gm-Message-State: AOAM531207QwZp1fgQRwaWscKu/uV0S3AcniVXE5W69+Yjxi6KngnWzM
        2RC2rrE11Gzx6OQEfYSBx7kAzOBCYmXsOit53O77hGP54J+pUgtydhzCe2Z2X9jtsPEE3wbjyEE
        WS2JYZTx1ntrb
X-Received: by 2002:a7b:cbda:0:b0:397:48d6:6c9f with SMTP id n26-20020a7bcbda000000b0039748d66c9fmr3283904wmi.10.1653390647673;
        Tue, 24 May 2022 04:10:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFuRjqrd2lUrDP97pOCIWHVQ3Wg0Ph+eJi2dLo7cH1N3zJH+xRTY2kVQFxiQFrVE9wCVph6g==
X-Received: by 2002:a7b:cbda:0:b0:397:48d6:6c9f with SMTP id n26-20020a7bcbda000000b0039748d66c9fmr3283886wmi.10.1653390647451;
        Tue, 24 May 2022 04:10:47 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id s1-20020adf8901000000b0020c547f75easm12292388wrs.101.2022.05.24.04.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 04:10:46 -0700 (PDT)
Message-ID: <8110c080-b439-4ed8-ffc8-13323ba3790c@redhat.com>
Date:   Tue, 24 May 2022 13:10:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, philmd@redhat.com,
        eblake@redhat.com, armbru@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
 <20220420115745.13696-9-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v7 08/13] s390x: topology: Adding drawers to STSI
In-Reply-To: <20220420115745.13696-9-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/2022 13.57, Pierre Morel wrote:
> Let's add STSI support for the container level 4, drawers,
> and provide the information back to the guest.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> @@ -470,6 +520,69 @@ static const TypeInfo drawer_info = {
>           { }
>       }
>   };
> +
> +/* --- NODE Definitions --- */
> +
> +/*
> + * Nodes are the first level of CPU topology we support
> + * only one NODE for the moment.
> + */
> +static char *node_bus_get_dev_path(DeviceState *dev)
> +{
> +    return g_strdup_printf("00");
> +}
g_strdup("00") please.

  Thomas

