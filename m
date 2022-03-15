Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1B14D99C6
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 11:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244214AbiCOK74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 06:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347798AbiCOK7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 06:59:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 335553CFC8
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 03:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647341915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j4q1mDkTkfU3rhMwSrf7xL1WLfewGHyjSGlrtIXdyt8=;
        b=T7EDu2xV275NETyx7EG9BEbB+wO4fU9kQnmfUAsW5KXsY2bPrdqAMjN80fndtWGiVyVxSp
        Dfi1veKNTP0twdnT3vIPv8kr//a24jtyl8WbM3yDUG4c05PB7asyNU1Kb3GvLM4NYIT7KW
        wsMeecsMTnMUmjaLcPitSUqa8nRoweQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-WOyV3MCQOkGW0LQRW0o0ZQ-1; Tue, 15 Mar 2022 06:58:34 -0400
X-MC-Unique: WOyV3MCQOkGW0LQRW0o0ZQ-1
Received: by mail-wr1-f71.google.com with SMTP id f18-20020adf9f52000000b00203d86759beso265070wrg.11
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 03:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j4q1mDkTkfU3rhMwSrf7xL1WLfewGHyjSGlrtIXdyt8=;
        b=earx4tfFhBzknbguGvMEpAp4h/LZEfwQyd+rmmoilK7JEyR8PLS+YbhLy8kKm5skT0
         1CNl88/Hw1uWY8rU9hCB7tcLFqnjVgBeRWoo1Qg41Vp98NM75TO7ZWTudC/GCcGpqITm
         3yRSDX2I1XrL4kyV+Mp+NrjPVUQJAubl58jVvspEA7davsem1bX4ZBpF7TJQp9gNn0aV
         rW2vDcDpUhN7GbLzZP0kjVfJZqx5CsLkpC6J8r2d9CxkMegWiz8qTtzaH6EOC4Wp7Rk1
         kkhYePOI4lEKqG6VdPr+BMKJrUAKdtUNaNSLvwkF8hPOFcs9kmOTi8CA3VZkeDbSe798
         6qZw==
X-Gm-Message-State: AOAM533y9PSHmpEwsR4sW1erh9dD5e5syZ5AsMWnZG6GbI0UjINCh6r4
        YugeiTgWCNUWpmw1RpSM5uRpay8VgtV8dDlOHkd+hXxCrFAvY6pXqJmAtb4j6xzlW0ox+X3lBNN
        3Pm+MkAMbgpiM
X-Received: by 2002:adf:e704:0:b0:203:750b:3d8 with SMTP id c4-20020adfe704000000b00203750b03d8mr19437736wrm.623.1647341912944;
        Tue, 15 Mar 2022 03:58:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8F5reu0obf+EcRrMdtMT6tiW8zTCLp5lDbrl9sclZsfIDBUU+L8B96ElFqtFOlRiqihEQ9A==
X-Received: by 2002:adf:e704:0:b0:203:750b:3d8 with SMTP id c4-20020adfe704000000b00203750b03d8mr19437702wrm.623.1647341912687;
        Tue, 15 Mar 2022 03:58:32 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id l41-20020a05600c1d2900b00389d3e18f8esm2188196wms.26.2022.03.15.03.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 03:58:31 -0700 (PDT)
Date:   Tue, 15 Mar 2022 10:58:28 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Laurent Vivier <lvivier@redhat.com>,
        Amit Shah <amit@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?iso-8859-1?Q?Herv=E9?= Poussineau <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Venture <venture@google.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Jean-Christophe Dubois <jcd@tribudubois.net>,
        Keith Busch <kbusch@kernel.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Eric Blake <eblake@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, xen-devel@lists.xenproject.org,
        qemu-ppc@nongnu.org, qemu-block@nongnu.org, haxm-team@intel.com,
        qemu-s390x@nongnu.org
Subject: Re: [PATCH 3/3] Use g_new() & friends where that makes obvious sense
Message-ID: <YjBxVFUw2DtBniYS@work-vm>
References: <20220314160108.1440470-1-armbru@redhat.com>
 <20220314160108.1440470-4-armbru@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314160108.1440470-4-armbru@redhat.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Markus Armbruster (armbru@redhat.com) wrote:
> g_new(T, n) is neater than g_malloc(sizeof(T) * n).  It's also safer,
> for two reasons.  One, it catches multiplication overflowing size_t.
> Two, it returns T * rather than void *, which lets the compiler catch
> more type errors.
> 
> This commit only touches allocations with size arguments of the form
> sizeof(T).
> 
> Patch created mechanically with:
> 
>     $ spatch --in-place --sp-file scripts/coccinelle/use-g_new-etc.cocci \
> 	     --macro-file scripts/cocci-macro-file.h FILES...
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Just a small patch then...

> diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
> index d65e744af9..aace12a787 100644
> --- a/migration/dirtyrate.c
> +++ b/migration/dirtyrate.c
> @@ -91,7 +91,7 @@ static struct DirtyRateInfo *query_dirty_rate_info(void)
>  {
>      int i;
>      int64_t dirty_rate = DirtyStat.dirty_rate;
> -    struct DirtyRateInfo *info = g_malloc0(sizeof(DirtyRateInfo));
> +    struct DirtyRateInfo *info = g_new0(DirtyRateInfo, 1);
>      DirtyRateVcpuList *head = NULL, **tail = &head;
>  
>      info->status = CalculatingState;
> @@ -112,7 +112,7 @@ static struct DirtyRateInfo *query_dirty_rate_info(void)
>              info->sample_pages = 0;
>              info->has_vcpu_dirty_rate = true;
>              for (i = 0; i < DirtyStat.dirty_ring.nvcpu; i++) {
> -                DirtyRateVcpu *rate = g_malloc0(sizeof(DirtyRateVcpu));
> +                DirtyRateVcpu *rate = g_new0(DirtyRateVcpu, 1);
>                  rate->id = DirtyStat.dirty_ring.rates[i].id;
>                  rate->dirty_rate = DirtyStat.dirty_ring.rates[i].dirty_rate;
>                  QAPI_LIST_APPEND(tail, rate);
> diff --git a/migration/multifd-zlib.c b/migration/multifd-zlib.c
> index aba1c88a0c..3a7ae44485 100644
> --- a/migration/multifd-zlib.c
> +++ b/migration/multifd-zlib.c
> @@ -43,7 +43,7 @@ struct zlib_data {
>   */
>  static int zlib_send_setup(MultiFDSendParams *p, Error **errp)
>  {
> -    struct zlib_data *z = g_malloc0(sizeof(struct zlib_data));
> +    struct zlib_data *z = g_new0(struct zlib_data, 1);
>      z_stream *zs = &z->zs;
>  
>      zs->zalloc = Z_NULL;
> @@ -164,7 +164,7 @@ static int zlib_send_prepare(MultiFDSendParams *p, Error **errp)
>   */
>  static int zlib_recv_setup(MultiFDRecvParams *p, Error **errp)
>  {
> -    struct zlib_data *z = g_malloc0(sizeof(struct zlib_data));
> +    struct zlib_data *z = g_new0(struct zlib_data, 1);
>      z_stream *zs = &z->zs;
>  
>      p->data = z;
> diff --git a/migration/ram.c b/migration/ram.c
> index 170e522a1f..3532f64ecb 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -2059,7 +2059,7 @@ int ram_save_queue_pages(const char *rbname, ram_addr_t start, ram_addr_t len)
>      }
>  
>      struct RAMSrcPageRequest *new_entry =
> -        g_malloc0(sizeof(struct RAMSrcPageRequest));
> +        g_new0(struct RAMSrcPageRequest, 1);
>      new_entry->rb = ramblock;
>      new_entry->offset = start;
>      new_entry->len = len;

For migration:
Acked-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

