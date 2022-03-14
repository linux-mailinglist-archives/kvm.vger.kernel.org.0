Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5796E4D8BEA
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 19:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiCNSsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 14:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiCNSs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 14:48:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C092646E
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 11:47:19 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id s11so15486292pfu.13
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 11:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3D0LjBNgeX0U7Mj4vXtRyZDTtfua4bw8Cy52CIrKEcE=;
        b=bfJjZ7cZndCjiv9SqHZ+gz/0oKTvtPYtt1gyUvSRswS4RFTsSgGz7nyM7i3zTsn0l7
         TrXxYHSA7bX7Fzgiv1e9Iq6gmhINLk7AIsPQriBACClelMz0NCtN/89NlMGaZHFIEEHe
         /OhsYPq9qlQnLm0YMaVyIacmu7wCbANhH2Z2P4N0wSykFtKrau7nb3gBpQsmYUKVBk6m
         E8WpjP0G7/3p45G4eCysz94M/86UmhtbyPnn54CCc6qGUdooPX6Yp49QzyFe0M/Xy3jo
         1qqQkUXRdKhFns65phIRg7cAgWHXb57FXw5ZrQBHTbqa96fWU7mOCIdjQB+niAOpUT4z
         co/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3D0LjBNgeX0U7Mj4vXtRyZDTtfua4bw8Cy52CIrKEcE=;
        b=GW31l56Umz7qehM3NelapihRrf5FaqnNdgc6UMjbaCon7Vrab5RU60o74VkjpiUJM3
         TvM6gIs8/fzA882cPINHHGKvXG/5ds3wcRzTmiASCkUSDEyWGT7QnpivStMRQL+5Ozr0
         jJPOdNvaEHLxnSKvVvYvMVzlsWeg0qC8VJgN1w6VuLNgTfiLhtUSCDKa7AsQlFc5pUd9
         3GR3oVS6VnllvEvHyQs4EBiipWnOlXxwXcMS6fU1rKOaYn3Ke3qpc7382yPERsRRLASB
         gvWjjp6rcw+EyuW67Oy9dNKPUKRcMlOnF1pGAqsxi9p2rNnU2u7QUCvb7QLEakSXEVTu
         8kzA==
X-Gm-Message-State: AOAM531to2JKbJepxYk/dY4FSKEhq0COhaZewUMskQjtVoAmhj0WrK/Z
        hoTJHJEZYGZVMxDE4bOV5mY=
X-Google-Smtp-Source: ABdhPJwzbMEzP8c3c5sDX3mZK/oaJ86+KZMRKvtRIkv5Sn/gYzmdRImdNKkSWPP0IhMCI2ss///OUA==
X-Received: by 2002:a63:ba47:0:b0:380:493a:7ed6 with SMTP id l7-20020a63ba47000000b00380493a7ed6mr20860797pgu.355.1647283638334;
        Mon, 14 Mar 2022 11:47:18 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id k14-20020a056a00134e00b004f83f05608esm2061600pfu.31.2022.03.14.11.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 11:47:17 -0700 (PDT)
Message-ID: <78a0febe-348a-8398-c57a-4b58038d041d@gmail.com>
Date:   Mon, 14 Mar 2022 19:46:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 2/3] 9pfs: Use g_new() & friends where that makes obvious
 sense
Content-Language: en-US
To:     Christian Schoenebeck <qemu_oss@crudebyte.com>,
        qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Peter Xu <peterx@redhat.com>, Klaus Jensen <its@irrelevant.dk>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, Ani Sinha <ani@anisinha.ca>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eric Blake <eblake@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Juan Quintela <quintela@redhat.com>,
        John Snow <jsnow@redhat.com>, Paul Durrant <paul@xen.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Mich ael Roth <michael.roth@amd.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Amit Shah <amit@kernel.org>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        haxm-team@intel.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>,
        Fabien Chouteau <chouteau@adacore.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        qemu-arm@nongnu.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Keith Busch <kbusch@kernel.org>, qemu-ppc@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eduardo Habkost <eduardo@habkost.net>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        qemu-block@nongnu.org, Max Filippov <jcmvbkbc@gmail.com>,
        qemu-s390x@nongnu.org, Patrick Venture <venture@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Jean-Christophe Dubois <jcd@tribudubois.net>,
        Corey Minyard <cminyard@mvista.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Colin Xu <colin.xu@intel.com>
References: <20220314160108.1440470-1-armbru@redhat.com>
 <20220314160108.1440470-3-armbru@redhat.com> <2292394.T0kE68JRDY@silver>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>
In-Reply-To: <2292394.T0kE68JRDY@silver>
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

Hi Christian,

On 14/3/22 17:42, Christian Schoenebeck wrote:
> On Montag, 14. März 2022 17:01:07 CET Markus Armbruster wrote:
>> g_new(T, n) is neater than g_malloc(sizeof(T) * n).  It's also safer,
>> for two reasons.  One, it catches multiplication overflowing size_t.
>> Two, it returns T * rather than void *, which lets the compiler catch
>> more type errors.
>>
>> This commit only touches allocations with size arguments of the form
>> sizeof(T).
>>
>> Patch created mechanically with:
>>
>>      $ spatch --in-place --sp-file scripts/coccinelle/use-g_new-etc.cocci \
>> 	     --macro-file scripts/cocci-macro-file.h FILES...
>>
>> Except this uncovers a typing error:
>>
>>      ../hw/9pfs/9p.c:855:13: warning: incompatible pointer types assigning to
>> 'QpfEntry *' from 'QppEntry *' [-Wincompatible-pointer-types] val =
>> g_new0(QppEntry, 1);
>> 		^ ~~~~~~~~~~~~~~~~~~~
>>      1 warning generated.
>>
>> Harmless, because QppEntry is larger than QpfEntry.  Fix to allocate a
>> QpfEntry instead.
>>
>> Cc: Greg Kurz <groug@kaod.org>
>> Cc: Christian Schoenebeck <qemu_oss@crudebyte.com>
>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>> ---
> 
> Reviewed-by: Christian Schoenebeck <qemu_oss@crudebyte.com>

FYI your domain is also quarantined by Google:

ARC-Authentication-Results: i=1; mx.google.com;
        dkim=fail header.i=@crudebyte.com header.s=lizzy header.b=olij9WvS;
        spf=softfail (google.com: domain of transitioning 
qemu_oss@crudebyte.com does not designate 172.105.152.211 as permitted 
sender) smtp.mailfrom=qemu_oss@crudebyte.com;
        dmarc=fail (p=QUARANTINE sp=QUARANTINE dis=QUARANTINE) 
header.from=crudebyte.com
Received-SPF: softfail (google.com: domain of transitioning 
qemu_oss@crudebyte.com does not designate 172.105.152.211 as permitted 
sender) client-ip=172.105.152.211;
Authentication-Results: mx.google.com;
        dkim=fail header.i=@crudebyte.com header.s=lizzy header.b=olij9WvS;
        spf=softfail (google.com: domain of transitioning 
qemu_oss@crudebyte.com does not designate 172.105.152.211 as permitted 
sender) smtp.mailfrom=qemu_oss@crudebyte.com;
        dmarc=fail (p=QUARANTINE sp=QUARANTINE dis=QUARANTINE) 
header.from=crudebyte.com
X-Rspamd-Queue-Id: AC61617709E
X-Spamd-Result: default: False [-2.01 / 7.00]; 
BAYES_HAM(-3.00)[100.00%]; SUSPICIOUS_RECIPS(1.50)[]; 
DMARC_POLICY_ALLOW(-0.50)[crudebyte.com,quarantine]; 
MID_RHS_NOT_FQDN(0.50)[]; R_DKIM_ALLOW(-0.20)[crudebyte.com:s=lizzy]; 
R_SPF_ALLOW(-0.20)[+ip4:91.194.90.13]; MIME_GOOD(-0.10)[text/plain]; 
MX_GOOD(-0.01)[]; RCVD_COUNT_ZERO(0.00)[0]; ASN(0.00)[asn:51167, 
ipnet:91.194.90.0/23, country:DE]; MIME_TRACE(0.00)[0:+]; 
FREEMAIL_CC(0.00)[redhat.com,linaro.org,gmail.com,vger.kernel.org,irrelevant.dk,adacore.com,anisinha.ca,netbsd.org,microsoft.com,kernel.org,lists.xenproject.org,users.sourceforge.jp,xen.org,huawei.com,reactos.org,amd.com,citrix.com,syrmia.com,ilande.co.uk,intel.com,kaod.org,nongnu.org,ispras.ru,gibson.dropbear.id.au,habkost.net,virtuozzo.com,google.com,amsat.org,tribudubois.net,mvista.com]; 
FROM_EQ_ENVFROM(0.00)[]; NEURAL_HAM(-0.00)[-0.923]; ARC_NA(0.00)[]; 
DKIM_TRACE(0.00)[crudebyte.com:+]; FROM_HAS_DN(0.00)[]; 
RCPT_COUNT_GT_50(0.00)[66]; TO_DN_SOME(0.00)[]; 
TO_MATCH_ENVRCPT_SOME(0.00)[]; TAGGED_RCPT(0.00)[]; 
RCVD_IN_DNSWL_FAIL(0.00)[91.194.90.13:server fail]
X-Rspamd-Server: atlanta189
