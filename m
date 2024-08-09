Return-Path: <kvm+bounces-23681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67FB494CBC7
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 09:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C6ED1C20966
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 07:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C30518C354;
	Fri,  9 Aug 2024 07:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OM6IR1/Z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YCDLeMgX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OM6IR1/Z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YCDLeMgX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F5612E7E
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 07:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723190286; cv=none; b=hEY1FDAYk/qxpCy0qsSRgMoDGygnR1UHOvUUto7YqtPg2/FtR92kg4nHpTBZk1FOyRFbFd/ZgfSai2CEhPOmNTQMbU/7t0CYbLvrSIpa1Nh6s7gYslcVSIyhaaU3a0Al3qptjngP3F1OpOHdPj25bThMBAXYyBDOUd7OHWFHEI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723190286; c=relaxed/simple;
	bh=2akUKSwWz1ZeWoQTpNJJVRnjVitlyKOqomHcLQ8Ex+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P+QVQBm7HhoiYomjCLx0NjbfX3lfo1gtfwnKd52I8YOTlxcfETrQdaoIAqdn5gDwOiSgmTzN6Ul+9OFG2FHs1VTvirK/a3ufGhPs3nK4wpauoXzG3NCE+ZeW8th3qdpPuRA5dUCwr59oi2O7fABX1XW5HMA/mRJbkguHiQVB0Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OM6IR1/Z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YCDLeMgX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OM6IR1/Z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YCDLeMgX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 026E21FF16;
	Fri,  9 Aug 2024 07:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723190283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l6W+uU1lUlPDFJUJ6ull0sC73zvSlpOSGqeI0md8Fkc=;
	b=OM6IR1/ZubAgZa12EDp1SWJ4C3sTvC86wBTCVJ1mi2ZJR0uPxse6JcXRSPPIGt04vrtaJX
	LTOsG643ackfxrh8PMhPgKGRu4ba2/9ASOYyow9hTU320akuV/3XcBVYpPXVv2xPH5tVWY
	CIepKgonpOj82K24PGunTvA2ogm2AzI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723190283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l6W+uU1lUlPDFJUJ6ull0sC73zvSlpOSGqeI0md8Fkc=;
	b=YCDLeMgXOiGUE8Ad27BzoBWsH+uvOJgub5f0pi7uYP10U5DPlgovTshGF0lgF/tTGI3PZP
	+3gDhnpUrhVhKKDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="OM6IR1/Z";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YCDLeMgX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723190283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l6W+uU1lUlPDFJUJ6ull0sC73zvSlpOSGqeI0md8Fkc=;
	b=OM6IR1/ZubAgZa12EDp1SWJ4C3sTvC86wBTCVJ1mi2ZJR0uPxse6JcXRSPPIGt04vrtaJX
	LTOsG643ackfxrh8PMhPgKGRu4ba2/9ASOYyow9hTU320akuV/3XcBVYpPXVv2xPH5tVWY
	CIepKgonpOj82K24PGunTvA2ogm2AzI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723190283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l6W+uU1lUlPDFJUJ6ull0sC73zvSlpOSGqeI0md8Fkc=;
	b=YCDLeMgXOiGUE8Ad27BzoBWsH+uvOJgub5f0pi7uYP10U5DPlgovTshGF0lgF/tTGI3PZP
	+3gDhnpUrhVhKKDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B32B11379A;
	Fri,  9 Aug 2024 07:58:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d9wsKgrMtWb+GgAAD6G6ig
	(envelope-from <cfontana@suse.de>); Fri, 09 Aug 2024 07:58:02 +0000
Message-ID: <00caf9c1-b6bf-4cd2-bc32-1a31f4b526a9@suse.de>
Date: Fri, 9 Aug 2024 09:58:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] kvm: refactor core virtual machine creation into
 its own function
To: Ani Sinha <anisinha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: zhao1.liu@intel.com, qemu-trivial@nongnu.org, kvm@vger.kernel.org,
 qemu-devel@nongnu.org
References: <20240809051054.1745641-1-anisinha@redhat.com>
 <20240809051054.1745641-3-anisinha@redhat.com>
Content-Language: en-US
From: Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20240809051054.1745641-3-anisinha@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -6.50
X-Rspamd-Queue-Id: 026E21FF16
X-Spamd-Result: default: False [-6.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spam-Flag: NO

gltm, thanks!

Reviewed-by: Claudio Fontana <cfontana@suse.de>

On 8/9/24 07:10, Ani Sinha wrote:
> Refactoring the core logic around KVM_CREATE_VM into its own separate function
> so that it can be called from other functions in subsequent patches. There is
> no functional change in this patch.
> 
> CC: pbonzini@redhat.com
> CC: zhao1.liu@intel.com
> CC: cfontana@suse.de
> CC: qemu-trivial@nongnu.org
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 86 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 53 insertions(+), 33 deletions(-)
> 
> changelog:
> v2: s/fprintf/warn_report as suggested by zhao
> v3: s/warn_report/error_report. function names adjusted to conform to
> other names. fprintf -> error_report() moved to its own patch.
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index ac168b9663..610b3ead32 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2385,6 +2385,57 @@ uint32_t kvm_dirty_ring_size(void)
>      return kvm_state->kvm_dirty_ring_size;
>  }
>  
> +static int kvm_create_vm(MachineState *ms, KVMState *s, int type)
> +{
> +    int ret;
> +
> +    do {
> +        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
> +    } while (ret == -EINTR);
> +
> +    if (ret < 0) {
> +        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
> +                    strerror(-ret));
> +
> +#ifdef TARGET_S390X
> +        if (ret == -EINVAL) {
> +            error_report("Host kernel setup problem detected. Please verify:");
> +            error_report("- for kernels supporting the switch_amode or"
> +                        " user_mode parameters, whether");
> +            error_report("  user space is running in primary address space");
> +            error_report("- for kernels supporting the vm.allocate_pgste "
> +                        "sysctl, whether it is enabled");
> +        }
> +#elif defined(TARGET_PPC)
> +        if (ret == -EINVAL) {
> +            error_report("PPC KVM module is not loaded. Try modprobe kvm_%s.",
> +                        (type == 2) ? "pr" : "hv");
> +        }
> +#endif
> +    }
> +
> +    return ret;
> +}
> +
> +static int kvm_machine_type(MachineState *ms)
> +{
> +    MachineClass *mc = MACHINE_GET_CLASS(ms);
> +    int type;
> +
> +    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
> +        g_autofree char *kvm_type;
> +        kvm_type = object_property_get_str(OBJECT(current_machine),
> +                                           "kvm-type",
> +                                           &error_abort);
> +        type = mc->kvm_type(ms, kvm_type);
> +    } else if (mc->kvm_type) {
> +        type = mc->kvm_type(ms, NULL);
> +    } else {
> +        type = kvm_arch_get_default_type(ms);
> +    }
> +    return type;
> +}
> +
>  static int kvm_init(MachineState *ms)
>  {
>      MachineClass *mc = MACHINE_GET_CLASS(ms);
> @@ -2467,45 +2518,14 @@ static int kvm_init(MachineState *ms)
>      }
>      s->as = g_new0(struct KVMAs, s->nr_as);
>  
> -    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
> -        g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
> -                                                            "kvm-type",
> -                                                            &error_abort);
> -        type = mc->kvm_type(ms, kvm_type);
> -    } else if (mc->kvm_type) {
> -        type = mc->kvm_type(ms, NULL);
> -    } else {
> -        type = kvm_arch_get_default_type(ms);
> -    }
> -
> +    type = kvm_machine_type(ms);
>      if (type < 0) {
>          ret = -EINVAL;
>          goto err;
>      }
>  
> -    do {
> -        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
> -    } while (ret == -EINTR);
> -
> +    ret = kvm_create_vm(ms, s, type);
>      if (ret < 0) {
> -        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
> -                    strerror(-ret));
> -
> -#ifdef TARGET_S390X
> -        if (ret == -EINVAL) {
> -            error_report("Host kernel setup problem detected. Please verify:");
> -            error_report("- for kernels supporting the switch_amode or"
> -                        " user_mode parameters, whether");
> -            error_report("  user space is running in primary address space");
> -            error_report("- for kernels supporting the vm.allocate_pgste "
> -                        "sysctl, whether it is enabled");
> -        }
> -#elif defined(TARGET_PPC)
> -        if (ret == -EINVAL) {
> -            error_report("PPC KVM module is not loaded. Try modprobe kvm_%s.",
> -                        (type == 2) ? "pr" : "hv");
> -        }
> -#endif
>          goto err;
>      }
>  


