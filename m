Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DF41E7908
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgE2JJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:09:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37456 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725795AbgE2JJv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 05:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590743388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=t4DRoImSm+q05u3SsUfhH9lvKV/SISKBgFYCE8lzSa4=;
        b=flnDPF1bd/xivagUsicsSWLfJShV814NF1xhwBNThlgsxhLLgYXO+1RSutbzKGs8lLJk5S
        xui0PuVF4CyVpPF9zb5VicCWsKgN30gy95VAKFjS1uHvzn4ZYyxKDoKmvmfz0uzExZkicz
        T0DimosD4NDoVTA1U1XPS6iLUWM6igI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-WCdrklM3OQaOMBvc1TOiKg-1; Fri, 29 May 2020 05:09:46 -0400
X-MC-Unique: WCdrklM3OQaOMBvc1TOiKg-1
Received: by mail-wr1-f71.google.com with SMTP id e7so284132wrp.14
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=t4DRoImSm+q05u3SsUfhH9lvKV/SISKBgFYCE8lzSa4=;
        b=iGHLsQoWPE8iSKd993JnpmzJa08S5FO02wVL0akO4IEdt+zzzYwr2zpAwBLMIF9D/M
         Qlqm1n3SnL59kZmt5R7rEeEwZ6izeaLk8f7k+5DzSg4Hc7t+WRugCNOzA5bwY5I1g96B
         3IG2s1H36mTHjLpAC4DWKd6Pjx67VjtL47iSBL2934pSMBIX/uZhahu8DRX9XGGo0WOP
         Qmb9M/P3DuplwCHGQllLuWkVEPLcwa+vAIyz2zuAZbJAaWqiUi4wzBZTBSxw3A0i0jfN
         3YiIj/t06PxxICIwsk3NV3Ew0cigmucwCae3ZFdt+V352m5JUpWJcxytfqSHxCRJqW7q
         QsoQ==
X-Gm-Message-State: AOAM531DysHq9MaKowKRd6HV0dUO17SiGw8jy9exJVGRNKFJsj2F/8vS
        gvOUzDH/AzDdVVIAY3pXQLdkEG07OXeMdsPxwkxzY70lBNaIgFcSAf7Nu0QOjm5rR1FV8jruq8+
        tpPAdYurei092
X-Received: by 2002:adf:ef83:: with SMTP id d3mr7416719wro.145.1590743384563;
        Fri, 29 May 2020 02:09:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4m/x86IIBlIaCYyPHB1jJDuzrdU88N3OPmtYpBreqcnUiaS8Mv9ye+80Za9sWBQq26EDGRg==
X-Received: by 2002:adf:ef83:: with SMTP id d3mr7416690wro.145.1590743384335;
        Fri, 29 May 2020 02:09:44 -0700 (PDT)
Received: from [192.168.1.34] (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id u7sm9244509wrm.23.2020.05.29.02.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:09:43 -0700 (PDT)
Subject: Re: [RFC v2 04/18] target/i386: sev: Embed SEVState in SevGuestState
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-5-david@gibson.dropbear.id.au>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <f6c47bd0-0213-743a-801d-6f90c033854c@redhat.com>
Date:   Fri, 29 May 2020 11:09:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-5-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/20 5:42 AM, David Gibson wrote:
> Currently SevGuestState contains only configuration information.  For
> runtime state another non-QOM struct SEVState is allocated separately.
> 
> Simplify things by instead embedding the SEVState structure in
> SevGuestState.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 54 +++++++++++++++++++++++++----------------------
>  1 file changed, 29 insertions(+), 25 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index b6ed719fb5..b4ab9720d6 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -35,6 +35,22 @@
>  
>  typedef struct SevGuestState SevGuestState;
>  
> +struct SEVState {
> +    uint8_t api_major;
> +    uint8_t api_minor;
> +    uint8_t build_id;
> +    uint32_t policy;
> +    uint64_t me_mask;
> +    uint32_t cbitpos;
> +    uint32_t reduced_phys_bits;
> +    uint32_t handle;
> +    int sev_fd;
> +    SevState state;
> +    gchar *measurement;
> +};
> +
> +typedef struct SEVState SEVState;

Maybe typedef & declaration altogether.

> +
>  /**
>   * SevGuestState:
>   *
> @@ -48,6 +64,7 @@ typedef struct SevGuestState SevGuestState;
>  struct SevGuestState {
>      Object parent_obj;
>  
> +    /* configuration parameters */
>      char *sev_device;
>      uint32_t policy;
>      uint32_t handle;
> @@ -55,25 +72,11 @@ struct SevGuestState {
>      char *session_file;
>      uint32_t cbitpos;
>      uint32_t reduced_phys_bits;
> -};
>  
> -struct SEVState {
> -    SevGuestState *sev_info;
> -    uint8_t api_major;
> -    uint8_t api_minor;
> -    uint8_t build_id;
> -    uint32_t policy;
> -    uint64_t me_mask;
> -    uint32_t cbitpos;
> -    uint32_t reduced_phys_bits;
> -    uint32_t handle;
> -    int sev_fd;
> -    SevState state;
> -    gchar *measurement;
> +    /* runtime state */
> +    SEVState state;
>  };
>  
> -typedef struct SEVState SEVState;
> -
>  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>  #define DEFAULT_SEV_DEVICE      "/dev/sev"
>  
> @@ -506,12 +509,12 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
>  }
>  
>  static int
> -sev_launch_start(SEVState *s)
> +sev_launch_start(SevGuestState *sev)
>  {
> +    SEVState *s = &sev->state;
>      gsize sz;
>      int ret = 1;
>      int fw_error, rc;
> -    SevGuestState *sev = s->sev_info;
>      struct kvm_sev_launch_start *start;
>      guchar *session = NULL, *dh_cert = NULL;
>  
> @@ -686,6 +689,7 @@ sev_vm_state_change(void *opaque, int running, RunState state)
>  void *
>  sev_guest_init(const char *id)
>  {
> +    SevGuestState *sev;
>      SEVState *s;
>      char *devname;
>      int ret, fw_error;
> @@ -693,27 +697,27 @@ sev_guest_init(const char *id)
>      uint32_t host_cbitpos;
>      struct sev_user_data_status status = {};
>  
> -    sev_state = s = g_new0(SEVState, 1);
> -    s->sev_info = lookup_sev_guest_info(id);
> -    if (!s->sev_info) {
> +    sev = lookup_sev_guest_info(id);
> +    if (!sev) {
>          error_report("%s: '%s' is not a valid '%s' object",
>                       __func__, id, TYPE_SEV_GUEST);
>          goto err;
>      }
>  
> +    sev_state = s = &sev->state;

I was going to suggest to clean that, but I see your next patch already
does the cleanup :)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

>      s->state = SEV_STATE_UNINIT;
>  
>      host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
>      host_cbitpos = ebx & 0x3f;
>  
> -    s->cbitpos = object_property_get_int(OBJECT(s->sev_info), "cbitpos", NULL);
> +    s->cbitpos = object_property_get_int(OBJECT(sev), "cbitpos", NULL);
>      if (host_cbitpos != s->cbitpos) {
>          error_report("%s: cbitpos check failed, host '%d' requested '%d'",
>                       __func__, host_cbitpos, s->cbitpos);
>          goto err;
>      }
>  
> -    s->reduced_phys_bits = object_property_get_int(OBJECT(s->sev_info),
> +    s->reduced_phys_bits = object_property_get_int(OBJECT(sev),
>                                          "reduced-phys-bits", NULL);
>      if (s->reduced_phys_bits < 1) {
>          error_report("%s: reduced_phys_bits check failed, it should be >=1,"
> @@ -723,7 +727,7 @@ sev_guest_init(const char *id)
>  
>      s->me_mask = ~(1UL << s->cbitpos);
>  
> -    devname = object_property_get_str(OBJECT(s->sev_info), "sev-device", NULL);
> +    devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
>      s->sev_fd = open(devname, O_RDWR);
>      if (s->sev_fd < 0) {
>          error_report("%s: Failed to open %s '%s'", __func__,
> @@ -754,7 +758,7 @@ sev_guest_init(const char *id)
>          goto err;
>      }
>  
> -    ret = sev_launch_start(s);
> +    ret = sev_launch_start(sev);
>      if (ret) {
>          error_report("%s: failed to create encryption context", __func__);
>          goto err;
> 

