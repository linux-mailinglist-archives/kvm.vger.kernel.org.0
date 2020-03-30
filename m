Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F981979FF
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgC3K6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:58:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:44670 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729525AbgC3K6n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585565922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=Q3crc4njuLeoM8ocQhCEFQNLgm17hH4bkqNOXW5hUto=;
        b=FCkIzJi07T2zGi1KgQcWxs6hz5WcpisHcwc1n3G7nJh1sYGyZybUon1Ps8g7gILObZOTMG
        B8XJ4cjhcNBn3Q3yF5DbVNRdyKLnnlO3plJ+UKQy7nNeQfIx28UNLguVuNA5tE2kWqa7s3
        BcOVw34XX1wOvwO9uMI1YbqghGZ6az0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-OK4tzafXOB6Wnec6tOPBVw-1; Mon, 30 Mar 2020 06:58:38 -0400
X-MC-Unique: OK4tzafXOB6Wnec6tOPBVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D5F21937FC0;
        Mon, 30 Mar 2020 10:58:37 +0000 (UTC)
Received: from [10.36.113.227] (ovpn-113-227.ams2.redhat.com [10.36.113.227])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 099A16EF9A;
        Mon, 30 Mar 2020 10:58:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests 2/2] s390x/smp: add minimal test for sigp sense
 running status
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>
References: <20200330084911.34248-1-borntraeger@de.ibm.com>
 <20200330084911.34248-3-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <2e511a31-b976-ec07-f0c4-a01c32ceba7f@redhat.com>
Date:   Mon, 30 Mar 2020 12:58:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330084911.34248-3-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.03.20 10:49, Christian Borntraeger wrote:
> make sure that sigp sense running status returns a sane value for
> stopped CPUs.
>=20
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  lib/s390x/smp.c |  2 +-
>  lib/s390x/smp.h |  2 +-
>  s390x/smp.c     | 11 +++++++++++
>  3 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 5ed8b7b..492cb05 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -58,7 +58,7 @@ bool smp_cpu_stopped(uint16_t addr)
>  	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
>  }
> =20
> -bool smp_cpu_running(uint16_t addr)
> +bool smp_sense_running_status(uint16_t addr)
>  {
>  	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) !=3D SIGP_CC_STATUS_STORE=
D)
>  		return true;
> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> index a8b98c0..639ec92 100644
> --- a/lib/s390x/smp.h
> +++ b/lib/s390x/smp.h
> @@ -40,7 +40,7 @@ struct cpu_status {
>  int smp_query_num_cpus(void);
>  struct cpu *smp_cpu_from_addr(uint16_t addr);
>  bool smp_cpu_stopped(uint16_t addr);
> -bool smp_cpu_running(uint16_t addr);
> +bool smp_sense_running_status(uint16_t addr);
>  int smp_cpu_restart(uint16_t addr);
>  int smp_cpu_start(uint16_t addr, struct psw psw);
>  int smp_cpu_stop(uint16_t addr);
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 79cdc1f..f9f143d 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -210,6 +210,16 @@ static void test_emcall(void)
>  	report_prefix_pop();
>  }
> =20
> +static void test_sense_running(void)
> +{
> +	report_prefix_push("sense_running");
> +	/* make sure CPU is stopped */
> +	smp_cpu_stop(1);
> +	report(!smp_sense_running_status(1), "CPU1 sense claims not running")=
;
> +	report_prefix_pop();
> +}
> +
> +
>  /* Used to dirty registers of cpu #1 before it is reset */
>  static void test_func_initial(void)
>  {
> @@ -319,6 +329,7 @@ int main(void)
>  	test_store_status();
>  	test_ecall();
>  	test_emcall();
> +	test_sense_running();
>  	test_reset();
>  	test_reset_initial();
>  	smp_cpu_destroy(1);
>=20

In kvm, we set/clear via kvm_arch_vcpu_load/kvm_arch_vcpu_put. This
means, that a VCPU will also be indicated as running, in case we perform
certain VCPU IOCTLs, while the VCPU is already stopped.

Especially, there is a theoretical race between stopping a VCPU, and it
still being in the kernel, and the other thread sensing the running
status. This is the case with !kvm_s390_user_cpu_state_ctrl(), when
leaving handle_stop() but also with kvm_s390_user_cpu_state_ctrl(), when
setting the MP state via kvm_arch_vcpu_ioctl_set_mpstate().

--=20
Thanks,

David / dhildenb

