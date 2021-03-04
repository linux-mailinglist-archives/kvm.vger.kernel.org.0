Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F00932CCD3
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 07:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbhCDG0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 01:26:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235182AbhCDG03 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 01:26:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614839103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YOee7X8Kdaszy+K+bsK5PH8LV+4q28xW28VP0oBbsvI=;
        b=fhE1saapqup9TnTVbkKXVwJTuXIWaFSTXN63E5J4K82P2N1XCq8u15cmbbkEzf0nJ+yVzV
        sDSYutzoK4oQvJZLujBNz0zuvTz8Qse6jsBPgar0VdAADvIJ6TZ5pRj/8zmSYekiKAFfrm
        FYai0NrAELUbluozVETqIiepAUw1ao8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-CEFjQCKxMYmCPiVygnz3IA-1; Thu, 04 Mar 2021 01:24:58 -0500
X-MC-Unique: CEFjQCKxMYmCPiVygnz3IA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C8B191270;
        Thu,  4 Mar 2021 06:24:56 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-31.ams2.redhat.com [10.36.112.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D52BC6F447;
        Thu,  4 Mar 2021 06:24:47 +0000 (UTC)
Subject: Re: [PATCH 02/19] target/s390x/kvm: Simplify debug code
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, haxm-team@intel.com,
        Colin Xu <colin.xu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Fontana <cfontana@suse.de>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-arm@nongnu.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, Wenchao Wang <wenchao.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
 <20210303182219.1631042-3-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c77cfa45-9aa1-5b1a-3dd4-861290b11907@redhat.com>
Date:   Thu, 4 Mar 2021 07:24:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210303182219.1631042-3-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/2021 19.22, Philippe Mathieu-Daudé wrote:
> We already have the 'run' variable holding 'cs->kvm_run' value.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/s390x/kvm.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
> index 7a892d663df..73f816a7222 100644
> --- a/target/s390x/kvm.c
> +++ b/target/s390x/kvm.c
> @@ -1785,8 +1785,7 @@ static int handle_intercept(S390CPU *cpu)
>       int icpt_code = run->s390_sieic.icptcode;
>       int r = 0;
>   
> -    DPRINTF("intercept: 0x%x (at 0x%lx)\n", icpt_code,
> -            (long)cs->kvm_run->psw_addr);
> +    DPRINTF("intercept: 0x%x (at 0x%lx)\n", icpt_code, (long)run->psw_addr);
>       switch (icpt_code) {
>           case ICPT_INSTRUCTION:
>           case ICPT_PV_INSTR:
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

