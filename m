Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699661E0935
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 10:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389239AbgEYIq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 04:46:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44336 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389225AbgEYIq0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 04:46:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590396385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=mvoxvn2nYczOXEWwcvmyHATWtBoRn/B5uUhxa/cIZRw=;
        b=K4XBPRzqbtshyVaJbRZDxDVgyqm4mb87Z+E53sL7zNKQc0P2Ef/0+i39t3DTf89ZJYoPo9
        Etn7rCTwUioxMhPXThrB8Z7XrHj6Cs727negkpXHH06MA8yg7Npynh08UjjXzdJrZXeVHB
        vznmNQnJZY+2aAsixBPD2sH9I5fqFmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-N1OpmQtENOGtxBcfl7YZXA-1; Mon, 25 May 2020 04:46:23 -0400
X-MC-Unique: N1OpmQtENOGtxBcfl7YZXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3718835B41;
        Mon, 25 May 2020 08:46:21 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-78.ams2.redhat.com [10.36.113.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C645160CCC;
        Mon, 25 May 2020 08:46:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x: stsi: Make output tap13 compatible
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, stzi@linux.ibm.com,
        mhartmay@linux.ibm.com, david@redhat.com, cohuck@redhat.com
References: <20200525084340.1454-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <da72e09e-8e38-38b5-01f7-05e96a121f27@redhat.com>
Date:   Mon, 25 May 2020 10:46:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200525084340.1454-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/2020 10.43, Janosch Frank wrote:
> In tap13 output # is a special character and only "skip" and "todo"
> are allowed to come after it. Let's appease our CI environment and
> replace # with "count".
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/stsi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 66b4257..b81cea7 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -129,11 +129,11 @@ static void test_3_2_2(void)
>  	}
>  
>  	report(!memcmp(data->vm[0].uuid, uuid, sizeof(uuid)), "uuid");
> -	report(data->vm[0].conf_cpus == smp_query_num_cpus(), "cpu # configured");
> +	report(data->vm[0].conf_cpus == smp_query_num_cpus(), "cpu count configured");
>  	report(data->vm[0].total_cpus ==
>  	       data->vm[0].reserved_cpus + data->vm[0].conf_cpus,
> -	       "cpu # total == conf + reserved");
> -	report(data->vm[0].standby_cpus == 0, "cpu # standby");
> +	       "cpu count total == conf + reserved");
> +	report(data->vm[0].standby_cpus == 0, "cpu count standby");
>  	report(!memcmp(data->vm[0].name, vm_name, sizeof(data->vm[0].name)),
>  	       "VM name == kvm-unit-test");

Reviewed-by: Thomas Huth <thuth@redhat.com>

