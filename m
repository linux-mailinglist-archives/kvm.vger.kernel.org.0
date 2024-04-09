Return-Path: <kvm+bounces-13978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6BC389D6EB
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 12:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BAC7284203
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 10:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8AA8286D;
	Tue,  9 Apr 2024 10:24:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF6280617;
	Tue,  9 Apr 2024 10:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712658257; cv=none; b=oYNlGj/WEF0tv8wiXizHTGY/znz0GQUQa01L0LZUudTtCwifBAkzMLpfEZ3PZwh59S8sCl0cX6kCVvP1+slWNoUZD/V00LTMe2o3T92a80jjYxfYG6Ax72hfwAUH8uNoNg/CmfQFPGUDlWhbL6o2RazEdoT9laXGet7ZZFbUJT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712658257; c=relaxed/simple;
	bh=FhZKi+CxyjFce8fDO6D8WspLyAWEgiejTD+k11QIiv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5Vvs4OyRnvR+d47jZ01JP7S7x2wW1i0myn5QqUX/esVz1cknAxvJqUsLaPFEa/yJNHbwSqAX0HPnYTl5DeEfr3V2kGHNqDdYinoaN9YCiaFUEmvgPbtKMAntG3IfHXcHu3uSDKVg6dHixgiXQgWF5z8sAF/ix3f9gx/SVJm1IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9925640E0187;
	Tue,  9 Apr 2024 10:24:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6BbwgN_kBiqb; Tue,  9 Apr 2024 10:24:06 +0000 (UTC)
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3A87940E01C5;
	Tue,  9 Apr 2024 10:23:54 +0000 (UTC)
Date: Tue, 9 Apr 2024 12:23:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 04/16] virt: sev-guest: Add vmpck_id to snp_guest_dev
 struct
Message-ID: <20240409102348.GBZhUXND0CDk7tGv8a@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-5-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240215113128.275608-5-nikunj@amd.com>

On Thu, Feb 15, 2024 at 05:01:16PM +0530, Nikunj A Dadhania wrote:
> Drop vmpck and os_area_msg_seqno pointers so that secret page layout
> does not need to be exposed to the sev-guest driver after the rework.
> Instead, add helper APIs to access vmpck and os_area_msg_seqno when
> needed. Added define for maximum supported VMPCK.

Do not talk about *what* the patch is doing in the commit message - that
should be obvious from the diff itself. Rather, concentrate on the *why*
it needs to be done.

Imagine one fine day you're doing git archeology, you find the place in
the code about which you want to find out why it was changed the way it
is now.

You do git annotate <filename> ... find the line, see the commit id and
you do:

git show <commit id>

You read the commit message and there's just gibberish and nothing's
explaining *why* that change was done. And you start scratching your
head, trying to figure out why...

I'm sure you're getting the idea.

> Also, change function is_vmpck_empty() to snp_is_vmpck_empty() in
> preparation for moving to sev.c.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> ---
>  arch/x86/include/asm/sev.h              |  1 +
>  drivers/virt/coco/sev-guest/sev-guest.c | 95 ++++++++++++-------------
>  2 files changed, 48 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 0c0b11af9f89..e4f52a606487 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -135,6 +135,7 @@ struct secrets_os_area {
>  } __packed;
>  
>  #define VMPCK_KEY_LEN		32
> +#define VMPCK_MAX_NUM		4
>  
>  /* See the SNP spec version 0.9 for secrets page format */
>  struct snp_secrets_page_layout {
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 596cec03f9eb..646eb215f3c7 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -55,8 +55,7 @@ struct snp_guest_dev {
>  		struct snp_derived_key_req derived_key;
>  		struct snp_ext_report_req ext_report;
>  	} req;
> -	u32 *os_area_msg_seqno;
> -	u8 *vmpck;
> +	unsigned int vmpck_id;
>  };
>  
>  static u32 vmpck_id;
> @@ -66,14 +65,22 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
>  /* Mutex to serialize the shared buffer access and command handling. */
>  static DEFINE_MUTEX(snp_cmd_mutex);
>  
> -static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
> +static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)

static functions don't need a prefix like "snp_".

>  {
> -	char zero_key[VMPCK_KEY_LEN] = {0};
> +	return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LEN;
> +}
>  
> -	if (snp_dev->vmpck)
> -		return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
> +static inline u32 *snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)

Ditto.

> +{
> +	return &snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
> +}
>  
> -	return true;
> +static bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev)
> +{
> +	char zero_key[VMPCK_KEY_LEN] = {0};
> +	u8 *key = snp_get_vmpck(snp_dev);
> +
> +	return !memcmp(key, zero_key, VMPCK_KEY_LEN);
>  }
>  
>  /*
> @@ -95,20 +102,22 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>   */
>  static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>  {
> -	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
> -		  vmpck_id);
> -	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
> -	snp_dev->vmpck = NULL;
> +	u8 *key = snp_get_vmpck(snp_dev);

Check whether is_vmpck_empty before you disable?

> +
> +	dev_alert(snp_dev->dev, "Disabling vmpck_id %u to prevent IV reuse.\n",
> +		  snp_dev->vmpck_id);
> +	memzero_explicit(key, VMPCK_KEY_LEN);
>  }
>  
>  static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>  {
> +	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
>  	u64 count;
>  
>  	lockdep_assert_held(&snp_cmd_mutex);
>  
>  	/* Read the current message sequence counter from secrets pages */
> -	count = *snp_dev->os_area_msg_seqno;
> +	count = *os_area_msg_seqno;

Why does that snp_get_os_area_msg_seqno() returns a pointer when you
deref it here again?

A function which returns a sequence number should return that number
- not a pointer to it.

Which then makes that u32 *os_area_msg_seqno redundant and you can use
the function directly.

IOW:

static inline u32 snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
{
        return snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
}

Simple.

>  
>  	return count + 1;
>  }
> @@ -136,11 +145,13 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>  
>  static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
>  {
> +	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
> +
>  	/*
>  	 * The counter is also incremented by the PSP, so increment it by 2
>  	 * and save in secrets page.
>  	 */
> -	*snp_dev->os_area_msg_seqno += 2;
> +	*os_area_msg_seqno += 2;

Yah, you have a getter but not a setter. You're setting it through the
pointer. Do you see the imbalance in the APIs?

>  }
>  
>  static inline struct snp_guest_dev *to_snp_dev(struct file *file)
> @@ -150,15 +161,22 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
>  	return container_of(dev, struct snp_guest_dev, misc);
>  }
>  
> -static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
> +static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
>  {
>  	struct aesgcm_ctx *ctx;
> +	u8 *key;
> +
> +	if (snp_is_vmpck_empty(snp_dev)) {
> +		pr_err("VM communication key VMPCK%u is null\n", vmpck_id);

		      "Empty/invalid VMPCK%u communication key"

or so.

In a pre-patch, fix all your user-visible strings to say "VMPCK"
- capitalized as it is an abbreviation.

> +		return NULL;
> +	}
>  
>  	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
>  	if (!ctx)
>  		return NULL;
>  
> -	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
> +	key = snp_get_vmpck(snp_dev);
> +	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
>  		pr_err("Crypto context initialization failed\n");
>  		kfree(ctx);
>  		return NULL;
> @@ -590,7 +608,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>  	mutex_lock(&snp_cmd_mutex);
>  
>  	/* Check if the VMPCK is not empty */
> -	if (is_vmpck_empty(snp_dev)) {
> +	if (snp_is_vmpck_empty(snp_dev)) {
>  		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>  		mutex_unlock(&snp_cmd_mutex);
>  		return -ENOTTY;
> @@ -667,32 +685,14 @@ static const struct file_operations snp_guest_fops = {
>  	.unlocked_ioctl = snp_guest_ioctl,
>  };
>  
> -static u8 *get_vmpck(int id, struct snp_secrets_page_layout *layout, u32 **seqno)
> +static bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
>  {
> -	u8 *key = NULL;
> +	if (WARN_ON((vmpck_id + 1) > VMPCK_MAX_NUM))
> +		return false;

So this will warn *and*, at the call site too. Let's tone that down.

>  
> -	switch (id) {
> -	case 0:
> -		*seqno = &layout->os_area.msg_seqno_0;
> -		key = layout->vmpck0;
> -		break;
> -	case 1:
> -		*seqno = &layout->os_area.msg_seqno_1;
> -		key = layout->vmpck1;
> -		break;
> -	case 2:
> -		*seqno = &layout->os_area.msg_seqno_2;
> -		key = layout->vmpck2;
> -		break;
> -	case 3:
> -		*seqno = &layout->os_area.msg_seqno_3;
> -		key = layout->vmpck3;
> -		break;
> -	default:
> -		break;
> -	}

Your commit message could explain why this is not needed, all of
a sudden.

> +	dev->vmpck_id = vmpck_id;
>  
> -	return key;
> +	return true;
>  }
>  
>  struct snp_msg_report_resp_hdr {
> @@ -728,7 +728,7 @@ static int sev_report_new(struct tsm_report *report, void *data)
>  	guard(mutex)(&snp_cmd_mutex);
>  
>  	/* Check if the VMPCK is not empty */
> -	if (is_vmpck_empty(snp_dev)) {
> +	if (snp_is_vmpck_empty(snp_dev)) {
>  		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>  		return -ENOTTY;
>  	}
> @@ -848,21 +848,20 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  		goto e_unmap;
>  
>  	ret = -EINVAL;
> -	snp_dev->vmpck = get_vmpck(vmpck_id, layout, &snp_dev->os_area_msg_seqno);
> -	if (!snp_dev->vmpck) {
> -		dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
> +	snp_dev->layout = layout;
> +	if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
> +		dev_err(dev, "invalid vmpck id %u\n", vmpck_id);
>  		goto e_unmap;
>  	}
>  
>  	/* Verify that VMPCK is not zero. */
> -	if (is_vmpck_empty(snp_dev)) {
> -		dev_err(dev, "vmpck id %d is null\n", vmpck_id);
> +	if (snp_is_vmpck_empty(snp_dev)) {
> +		dev_err(dev, "vmpck id %u is null\n", vmpck_id);

s!null!Invalid/Empty!

>  		goto e_unmap;
>  	}
>  
>  	platform_set_drvdata(pdev, snp_dev);
>  	snp_dev->dev = dev;
> -	snp_dev->layout = layout;
>  
>  	/* Allocate the shared page used for the request and response message. */
>  	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
> @@ -878,7 +877,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  		goto e_free_response;
>  
>  	ret = -EIO;
> -	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
> +	snp_dev->ctx = snp_init_crypto(snp_dev);
>  	if (!snp_dev->ctx)
>  		goto e_free_cert_data;
>  
> @@ -903,7 +902,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto e_free_ctx;
>  
> -	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
> +	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %u)\n", vmpck_id);

Yet another spelling: "vmpck_id". Unify all those in a pre-patch pls
because it looks stupid.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

