Return-Path: <kvm+bounces-72543-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +EsNMYYKp2kDcgAAu9opvQ
	(envelope-from <kvm+bounces-72543-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 17:21:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A5941F39FF
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 17:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 204323046AA9
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 16:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A514D90A5;
	Tue,  3 Mar 2026 16:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NaZsYyrE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170F34D8D97
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 16:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772554803; cv=pass; b=ER4mVLHn7bSuRq3qjcQUbFRD6qeqiYCN5jREMGJB4MksU/IeIIEL75w1Yn9IIS/o8ibTry8930gwSWcrjKtEZNDPkPwxuDpqP/+ry5g6I5vc5lmrPs+RlFBo+b6zndKq49qLh5BSATDJ1Jp+rWZ4U1nXOJYQ7x4PWxaDln9IEzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772554803; c=relaxed/simple;
	bh=TuaIpdtAo6HMTw26KmiSJHqwZmKYbaTuPkjUtZ6mEW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S4RLvDUtrY9L61oJvP8WK4ujfUHza8p5TWzJtAxHSXuEZJGOpeJy1c974NSzH1Ut7rSAfEzlBioeVcJejA9Ar2OjB2LBwYdK37zNUCvmhwvzk0zHsdDLev18jtn7g2teufCNEUMkTuQHTnJRH/hNY2fcn6HTsFYSj/EqAWoCSzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NaZsYyrE; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-506a355aedfso463871cf.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 08:20:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772554801; cv=none;
        d=google.com; s=arc-20240605;
        b=f7NNRcElE6CMTxwLlNd3j+01FN0mRqMVHybizaVklXuMwAwLLUsjsF5+R7fAcZuFc7
         Qo68F8rPSwdt+B+rQ3H1lp9kxYFMv2rM0NvDSDLFLPHED2NdrLWOs/QdNDFk54gxgZf3
         TM7tffczcnrL/LELpahKzAxUiIBpo2Ikra01l09PsZKBxv9GCuph9v19IqA7EitMaGVp
         qQWAJLt3IGj15O75/BAR7MWlCUzxj6HrAdcQF2/1qay9s/+jGV8CPXblSX36dcpp9UHx
         8Y6BfD/YITnAtzfMA9VA0NNR7MXSz0eFNZbiJ2nMt9URgSVJlvrg9Hu2m3fLeMLchAK+
         OVag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y1FNE3zJnAV7jwSHlyD2K0yRZG6peHg0VKql7rlqcBs=;
        fh=Ug7bGA5I41Ne7mSfQSLtygXFFRD+typkN4IeOOBq1Js=;
        b=hjamz98sz9xfxAFdGndUACyyHm+h9HPAnqinE96C6310Z4re4JgRxjrbSz/u5Jm/Be
         DNtk+54libuHGkFLXVzJGChvASYZcZZWKg/zdcKpvUKb7PDUKLexE3XFhPUBSl6RNUf8
         C+3rjmo1XGHxbA+4qc288VxmG28Q8US4KP1PCbHnGpQXOHH0o8Q8Y1dcf8Pxo6AObq8y
         6HU4RawQbHG8bXGB4dh16kblmoJQUOIwOGOIzFIHjecJVl0qEmRNxMVMVRpK+oNobyYW
         OHSAIpSS4f/EBf0W4lquz4A1zxSOlEh0vT9JJv4wGaBwrscvxF1k5AT67hvPn0Cy2BoE
         Dlzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772554801; x=1773159601; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1FNE3zJnAV7jwSHlyD2K0yRZG6peHg0VKql7rlqcBs=;
        b=NaZsYyrEvs0z697upks7XqyOVFsqK5UqLa/WwXb2LUXAp00nGxMmPmPGv1i6fIff5F
         HPvemhRTBlrBqTHurkfl1ElTz+xW6Ioh1qy39eHV26NN2VwUkYAWqoQfjNU5NXxtIQxL
         dxt1v5I91R6YtNjAEU5fEdxFBrF0y3oUlZIWvpdFkcyyfx/pPngDH69MxOud+DPk5gP2
         wZPF6saKfIbbuGAcZDBP3GRZgxoRzgnu8fq0SJCZJVU0IJ7r6e6MvYT1uIM5as96zeVB
         LpX8Lo7ydAdOtvfmxQeDCHyKwk0f9NwX8AVQW3KlSNITExZZlXglDkz5Jy6/mv4OTPze
         UKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772554801; x=1773159601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y1FNE3zJnAV7jwSHlyD2K0yRZG6peHg0VKql7rlqcBs=;
        b=s1FoaMvoS0SX1jPGL7ohHF2BX5BaocZWXCSXZN8SoQsiSm+i2eRVGO8O9J6rzuafm3
         XBm6UqsEqlH1jcIAOsjjUNXUGDjT7II3NbW2U0A4WrGTPsHWuUoNN0vn1v1GWe44ct/B
         8uCbhWXctC7Vbh6oZ5/CcjKrgJh3I1ktadNMc4NErk+B3XOLVCLdkGM9kphL3ZEKeo4w
         y4YX32IWq0yFgHZCrtn8lhfcgShFW2qXKZh4Az2FHORkL1azJfXo35So8MmIeVRg+8jJ
         G4USKLm04wkbRyDktuUwlgNuSMYKWu7GHC3q9rHsVTc46AJpea/YoPZHL60UUJQMiW1+
         dofA==
X-Forwarded-Encrypted: i=1; AJvYcCWFQJTsGp9dbkFLzerHXq9Qg2SQgz/gMiSZNgP4SC+hUalunwlVCNQYoOK7exuChjL7k0M=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywfcw/tOfjLogS9TSPs9bSgVMEE5EyUpPnEUxFpNM7dfnI7sARG
	MnyFQqk0h4A+EE883g6FIJR6fFW1YNb+Pk7RmEqoJYKSbMfSL+HmMvqYGHcsa/4a/6cUwRBz1vu
	EyHUC9Xkxwuc3R8KPZe/4N4ADu+eynke7/6Jw4+Bo
X-Gm-Gg: ATEYQzweSjJES02oSTCYGtvnOGs0Dek/9dR4GpKR8OQHoezp8/0baHqL8snWAJwrXWY
	Z5juxfRkxCwpvwdgNQLj8w8x4z1SmzKZunwfIZMb8Lesu7wiSqBV+kezup7mMNZrPqcnKKRoD0r
	Nuk/yL4gU/rA5t9Se5tvphmS5aNi5iKQz5r1yyKkDvqzurxNDzpp6vc+8DnIrBRTuA7FL9i/b+F
	W9IREfolE1BEGtV8O+5sUpX6z8EVa1WfjQl17NmEEUx+pLKiJVLPchrPwwka6pWT3tAdNO72mUZ
	Df+5nzwd
X-Received: by 2002:ac8:5fc1:0:b0:4ff:bffa:d9e4 with SMTP id
 d75a77b69052e-5076186d139mr6450281cf.13.1772554800173; Tue, 03 Mar 2026
 08:20:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227233928.84530-1-rananta@google.com> <20260227233928.84530-4-rananta@google.com>
In-Reply-To: <20260227233928.84530-4-rananta@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 3 Mar 2026 08:19:48 -0800
X-Gm-Features: AaiRm50jxl0NT5-E96wyivjLgvOZwflwJnrhgy_K5Hs34CZB2g65Gx0Ch37Xp4M
Message-ID: <CAJHc60wpvP_YE28cfRbmM7JzkqGRtMPabVvX=YDS3O3UzyjCVg@mail.gmail.com>
Subject: Re: [PATCH v5 3/8] vfio: selftests: Introduce a sysfs lib
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6A5941F39FF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72543-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 3:39=E2=80=AFPM Raghavendra Rao Ananta
<rananta@google.com> wrote:
> +
> +char *sysfs_sriov_vf_bdf_get(const char *pf_bdf, int i)
> +{
> +       char vf_path[PATH_MAX];
> +       char path[PATH_MAX];
> +       char *out_vf_bdf;
> +       int ret;
> +
> +       out_vf_bdf =3D calloc(16, sizeof(char));
> +       VFIO_ASSERT_NOT_NULL(out_vf_bdf);
> +
> +       snprintf_assert(path, PATH_MAX, "/sys/bus/pci/devices/%s/virtfn%d=
", pf_bdf, i);
> +
> +       ret =3D readlink(path, vf_path, PATH_MAX);
> +       VFIO_ASSERT_NE(ret, -1);
> +
In one of the recent runs (with some other local changes), I see
'vf_path' still holds the contents from a previous stack frame,
appended at the end.
readlink() man page mentions that the output buf is not '\0'
terminated and the reason why I'm running into this. Either we
terminate it explicitly or initialize 'vf_path' with an empty string.
I'll send out a v6 with the first approach taking care of this
wherever readlink() is used.

Thank you.
Raghavendra

