Return-Path: <kvm+bounces-91-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72DD97DBD96
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:16:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52F7A1C20AED
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B1D18C3B;
	Mon, 30 Oct 2023 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XRV4WUTc"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9F918C21
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:16:35 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372D9D9
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:16:33 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-408c6ec1fd1so111285e9.1
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698682591; x=1699287391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cqIfDguuwM8szZAtDVbLhY+g3EClj8oauil5zhjmZw=;
        b=XRV4WUTcqTtEUmcbiBe/7DvcqHoqnz4ZyqD3z43Ub0Q8ryhu13P1Vh+4j/pXvu8yMa
         8RCRw6E4AkLj3OeqgFlchVHbQzH7G5BLCV3beERjFFvPkBNQlt9WhHUkD6IcVgDUEEpV
         FSRhKrDdIfjt6umGHwspS7MUHFKSAnISdKw3mkEq5hBoMptaH0sm5NVzYp0FmZQrRO+L
         26/NR9qvAcICpD650Df8Po3Lym9kaeYLLwPQSZZ+MCn5DD4PiAYYozkoZrnb4KebZkzw
         CZQWpZY8a/PryBlgbRXbvWVgki/4OvpIlOl9x/zGIvLNRafHnLPD0bS4jT8ny7G+vn5Z
         S9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698682591; x=1699287391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0cqIfDguuwM8szZAtDVbLhY+g3EClj8oauil5zhjmZw=;
        b=tiXe3RGsYF9wLWB9LdiWqtjjElU5043v2I1XP9buA2vhiH6zTSD/1/+HID/qhdaloO
         xmWGekJVLosT6TF9x6zVzyOfrYwSXI8rC3gyd2aI8AUBL2DDNpmia2kx63qM1PSrj8J4
         XptsfzHt7dL7TAePdomc5nNihYNjSC3yC1UjTa3AOBZetRuvm803Adk7kZZD8P0NEUZb
         KQumZI3iCCRLwKOLpzRgYfxCEpN5c3xduKY07tPaxs9/iGNkciYo5Sjteq23wCmwMBoO
         0VdBgsui72fvkRA6OOMziDR3NXbzduzFG6grVdPLU6tNqQeCrosm+phkKrOV9qki+ZyI
         KguA==
X-Gm-Message-State: AOJu0YyFOxpKAnzTmGTUUt7b7FFmFzvxqHCnxHSrFOBNl+0nB9oBTcVX
	ESZgtvYClyp/TTc6bY42S4C2kUOXBd91G3mhMhkr2Q==
X-Google-Smtp-Source: AGHT+IFW57OXDy5bWwRXULtPdqrc1qOo26G4aRNTieSFhqmD44MpYmOpKsAVyPbbqsfJbhCu70cZaMPIZvQe5J8Yf+8=
X-Received: by 2002:a05:600c:1c81:b0:3f4:fb7:48d4 with SMTP id
 k1-20020a05600c1c8100b003f40fb748d4mr132874wms.3.1698682591394; Mon, 30 Oct
 2023 09:16:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231030063652.68675-1-nikunj@amd.com> <20231030063652.68675-6-nikunj@amd.com>
In-Reply-To: <20231030063652.68675-6-nikunj@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 30 Oct 2023 09:16:20 -0700
Message-ID: <CAAH4kHY_sM0DTL+EVz3GNDq1q_5S4FH1Ku9EMV0HOzFAY1s4QQ@mail.gmail.com>
Subject: Re: [PATCH v5 05/14] virt: sev-guest: Add vmpck_id to snp_guest_dev struct
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 29, 2023 at 11:38=E2=80=AFPM Nikunj A Dadhania <nikunj@amd.com>=
 wrote:
>
> Drop vmpck and os_area_msg_seqno pointers so that secret page layout
> does not need to be exposed to the sev-guest driver after the rework.
> Instead, add helper APIs to access vmpck and os_area_msg_seqno when
> needed.
>
> Also, change function is_vmpck_empty() to snp_is_vmpck_empty() in
> preparation for moving to sev.c.
>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 85 ++++++++++++-------------
>  1 file changed, 42 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/=
sev-guest/sev-guest.c
> index 5801dd52ffdf..4dd094c73e2f 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -50,8 +50,7 @@ struct snp_guest_dev {
>
>         struct snp_secrets_page_layout *layout;
>         struct snp_req_data input;
> -       u32 *os_area_msg_seqno;
> -       u8 *vmpck;
> +       unsigned int vmpck_id;
>  };
>
>  static u32 vmpck_id;
> @@ -61,14 +60,22 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when =
communicating with the PSP.
>  /* Mutex to serialize the shared buffer access and command handling. */
>  static DEFINE_MUTEX(snp_cmd_mutex);
>
> -static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
> +static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)
>  {
> -       char zero_key[VMPCK_KEY_LEN] =3D {0};
> +       return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LE=
N;
> +}
>
> -       if (snp_dev->vmpck)
> -               return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
> +static inline u32 *snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_d=
ev)
> +{
> +       return &snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
> +}
>
> -       return true;
> +static bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev)
> +{
> +       char zero_key[VMPCK_KEY_LEN] =3D {0};
> +       u8 *key =3D snp_get_vmpck(snp_dev);
> +
> +       return !memcmp(key, zero_key, VMPCK_KEY_LEN);
>  }
>
>  /*
> @@ -90,20 +97,22 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_=
dev)
>   */
>  static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>  {
> +       u8 *key =3D snp_get_vmpck(snp_dev);
> +
>         dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reus=
e.\n",
> -                 vmpck_id);
> -       memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
> -       snp_dev->vmpck =3D NULL;
> +                 snp_dev->vmpck_id);
> +       memzero_explicit(key, VMPCK_KEY_LEN);
>  }

We disable the VMPCK because we believe the guest to be under attack,
but this only clears a single key. Shouldn't we clear all VMPCK keys
in the secrets page for good measure? If at VMPCK > 0, most likely the
0..VMPCK-1 keys have been zeroed by whatever was prior in the boot
stack, but still better to be safe.

>
>  static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>  {
> +       u32 *os_area_msg_seqno =3D snp_get_os_area_msg_seqno(snp_dev);
>         u64 count;
>
>         lockdep_assert_held(&snp_dev->cmd_mutex);
>
>         /* Read the current message sequence counter from secrets pages *=
/
> -       count =3D *snp_dev->os_area_msg_seqno;
> +       count =3D *os_area_msg_seqno;
>
>         return count + 1;
>  }
> @@ -131,11 +140,13 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *=
snp_dev)
>
>  static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
>  {
> +       u32 *os_area_msg_seqno =3D snp_get_os_area_msg_seqno(snp_dev);
> +
>         /*
>          * The counter is also incremented by the PSP, so increment it by=
 2
>          * and save in secrets page.
>          */
> -       *snp_dev->os_area_msg_seqno +=3D 2;
> +       *os_area_msg_seqno +=3D 2;
>  }
>
>  static inline struct snp_guest_dev *to_snp_dev(struct file *file)
> @@ -145,15 +156,22 @@ static inline struct snp_guest_dev *to_snp_dev(stru=
ct file *file)
>         return container_of(dev, struct snp_guest_dev, misc);
>  }
>
> -static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
> +static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
>  {
>         struct aesgcm_ctx *ctx;
> +       u8 *key;
> +
> +       if (snp_is_vmpck_empty(snp_dev)) {
> +               pr_err("SNP: vmpck id %d is null\n", snp_dev->vmpck_id);
> +               return NULL;
> +       }
>
>         ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
>         if (!ctx)
>                 return NULL;
>
> -       if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
> +       key =3D snp_get_vmpck(snp_dev);
> +       if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
>                 pr_err("SNP: crypto init failed\n");
>                 kfree(ctx);
>                 return NULL;
> @@ -586,7 +604,7 @@ static long snp_guest_ioctl(struct file *file, unsign=
ed int ioctl, unsigned long
>         mutex_lock(&snp_dev->cmd_mutex);
>
>         /* Check if the VMPCK is not empty */
> -       if (is_vmpck_empty(snp_dev)) {
> +       if (snp_is_vmpck_empty(snp_dev)) {
>                 dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>                 mutex_unlock(&snp_dev->cmd_mutex);
>                 return -ENOTTY;
> @@ -656,32 +674,14 @@ static const struct file_operations snp_guest_fops =
=3D {
>         .unlocked_ioctl =3D snp_guest_ioctl,
>  };
>
> -static u8 *get_vmpck(int id, struct snp_secrets_page_layout *layout, u32=
 **seqno)
> +bool snp_assign_vmpck(struct snp_guest_dev *dev, int vmpck_id)
>  {
> -       u8 *key =3D NULL;
> +       if (WARN_ON(vmpck_id > 3))
> +               return false;

The vmpck_id is an int for some reason, so < 0 is also a problem. Can
we not use unsigned int?

>
> -       switch (id) {
> -       case 0:
> -               *seqno =3D &layout->os_area.msg_seqno_0;
> -               key =3D layout->vmpck0;
> -               break;
> -       case 1:
> -               *seqno =3D &layout->os_area.msg_seqno_1;
> -               key =3D layout->vmpck1;
> -               break;
> -       case 2:
> -               *seqno =3D &layout->os_area.msg_seqno_2;
> -               key =3D layout->vmpck2;
> -               break;
> -       case 3:
> -               *seqno =3D &layout->os_area.msg_seqno_3;
> -               key =3D layout->vmpck3;
> -               break;
> -       default:
> -               break;
> -       }
> +       dev->vmpck_id =3D vmpck_id;
>
> -       return key;
> +       return true;
>  }
>
>  static int __init sev_guest_probe(struct platform_device *pdev)
> @@ -713,14 +713,14 @@ static int __init sev_guest_probe(struct platform_d=
evice *pdev)
>                 goto e_unmap;
>
>         ret =3D -EINVAL;
> -       snp_dev->vmpck =3D get_vmpck(vmpck_id, layout, &snp_dev->os_area_=
msg_seqno);
> -       if (!snp_dev->vmpck) {
> +       snp_dev->layout =3D layout;
> +       if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
>                 dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
>                 goto e_unmap;
>         }
>
>         /* Verify that VMPCK is not zero. */
> -       if (is_vmpck_empty(snp_dev)) {
> +       if (snp_is_vmpck_empty(snp_dev)) {
>                 dev_err(dev, "vmpck id %d is null\n", vmpck_id);
>                 goto e_unmap;
>         }
> @@ -728,7 +728,6 @@ static int __init sev_guest_probe(struct platform_dev=
ice *pdev)
>         mutex_init(&snp_dev->cmd_mutex);
>         platform_set_drvdata(pdev, snp_dev);
>         snp_dev->dev =3D dev;
> -       snp_dev->layout =3D layout;
>
>         /* Allocate the shared page used for the request and response mes=
sage. */
>         snp_dev->request =3D alloc_shared_pages(dev, sizeof(struct snp_gu=
est_msg));
> @@ -744,7 +743,7 @@ static int __init sev_guest_probe(struct platform_dev=
ice *pdev)
>                 goto e_free_response;
>
>         ret =3D -EIO;
> -       snp_dev->ctx =3D snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
> +       snp_dev->ctx =3D snp_init_crypto(snp_dev);
>         if (!snp_dev->ctx)
>                 goto e_free_cert_data;
>
> --
> 2.34.1
>


--=20
-Dionna Glaze, PhD (she/her)

