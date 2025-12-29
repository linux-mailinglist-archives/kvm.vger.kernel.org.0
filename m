Return-Path: <kvm+bounces-66789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 473F1CE7C83
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B75AC30022D3
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4DE32B9A7;
	Mon, 29 Dec 2025 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z6suSFO0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9D71E98E3
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030896; cv=none; b=cDcEeDFQGbUD4DPVUwDgy/sDnIkysXOdu2l5zcakmXkxbzOnj27GxQa+GZpktSVLSfqVMpSj8s74Uu+8G9EWSZSOj4AR3Gss1qbEKaBFLdov0evU82mn//Dxq9uqFQuPq6rAakrwTy2vdRK4uF5/FCoZgviq/4QMVetrZMBl+GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030896; c=relaxed/simple;
	bh=BL/i5tZPB/4wrnQtytDph+6ZeFmnMizqToMkOS0r0Ac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yuxqt7f3VDz4hvwtslVAAl8IM2xIFFW4n5ISrdUZxYb3kt1C5ZWbDiNdedd5GhvguCRnaU8T/XfyNL97sfYcA8z0svCVcauqaed6Jtld81c4+EXuKSsHwiAt2TsJpQtf1K3nV8xlVl2mGVFZmARuGr6KgAVhIUVB/FOEaEMAGqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=z6suSFO0; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7e2762ad850so9638855b3a.3
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767030894; x=1767635694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GYQJIN3N003Jiaq44UoCSPHrWkIZlb0Npd6wbYqgtTA=;
        b=z6suSFO0h325IRcboxZNd1HlARfsC8i5BT0Q1K9f05pbTCp54x2Zrnf39XPTknn16M
         0TBQv4ZSWlHhbWLW593ILq9k86r/hzgg3q9/y7fP60UAi0Uv7ZY/0kNZ0dV7HS7B5RPq
         ECnXnJYhQcLojNe7m7i0URgwmJLDK5dcBU42sU1RADI3vBU8+PLv8d1+fwTQuwGi2hs9
         RBqIfRSF1hDwoqkyNiP9dG98o3q8NE6D//neuiVhDMN0KfKz+/zL9t1h+b56mTtnKWzu
         +xukDKVJNTbUm+0RNrIyjRA+aLsusLycXkBe9Sy0BItcyRaEj06z1bQaOWsaU5ZSyyRf
         R/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030894; x=1767635694;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GYQJIN3N003Jiaq44UoCSPHrWkIZlb0Npd6wbYqgtTA=;
        b=tkhgIz7YHhAK40LYj2n5tsy6AS+uGiD+vpADcE8Qo36fkjtPYGHi2ToaDjhC47Td5U
         /fBGNMvrXDpc2Mp2E3R/Zip4jV0v8KikDphQwtq9JxZXkx9fbnyaVwE8swucvZV5+q0j
         eMBHM0dt9QMPO47WyiFd6ePl1Wdt7UXRoCUxaAnY6+b56NKTRpRMebAUzikqioH5Tamc
         aWYmh/UxTNeI1/6LaAN9sMeRUFWdK8hrRp2FwUyneqoQlK+dAbjL4AHfgldbtTGsgFUL
         rhyAEHF+MhVV9vnHiEce+evjvwxEFEWBeyisg8X640qCwlc7QwdogdEF1FL8N3Cgsg42
         +B1w==
X-Forwarded-Encrypted: i=1; AJvYcCWCt7024Al0pYhwugvv+OtFKQNuw6FcesOBVq2/RhYCMVKAMUXmiZ0TCduZdeJmlVEaqrg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg14JBiT4wjlT8YOuNNm9Emq8hUDHxUDCujsmVnpx1wbxNm2Xy
	fHy+1iE9gubOuG1hx/HRh56eCVFZq5e+eMB82KoMzhNXJq/V+ryoVCjbl5XePHnBujQ=
X-Gm-Gg: AY/fxX5jF32ZdzIJhtIQhdjczeZwWAVN0C+mg/E2d9rrXT2VJRETJRd32V369czJ1NL
	C/CvachRmv/Ygy8/pigQP+RfmU5uGxhhSoP9idGdQhCr55s/MGzxRMpUufwM+hhqKhJ7EtrTcMf
	SsCdnyZ7UiwpgBljkK0DBsbG9YgcPFSfRPMMeNxjKEv9k95SrVel4UzOwR+i8Tg7bumxbxrWPHu
	MKkHgW2ux9wQxdfu5e+gKlyDiLQvf3G7GDfmdVLzUjpqoaHq27MtFJ3ScS7sYAZoO14KdPjGurF
	mRvv4T21JKa+8kR6L104im4gXRYkShreWvqZJ4//pAZY7vwrTh8dWWUA2ZGxFAalW4BXbP5k56D
	Vj/csCjJQYk3ke2iyma369DndeG5UKSDz17gzUvT5jxn0OsJbk8NXrhaQ/s9qXSY4jBqtreVG2h
	THKkn5UncQk7pCp/RBMgzDjJQG273JUW2O46Al3xReJOUn0gtOrCEjV1tt
X-Google-Smtp-Source: AGHT+IEKZHs2pS6BNNt1GybjHDp4orkhKQ29/lQ8hAEBaQVijQHH0IVExd1f+l7lYmSNDJ+IQ3yGIw==
X-Received: by 2002:a05:6a00:7613:b0:7ff:acc3:2f40 with SMTP id d2e1a72fcca58-7ffacc33e69mr22056701b3a.26.1767030894257;
        Mon, 29 Dec 2025 09:54:54 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7aa328basm30231550b3a.11.2025.12.29.09.54.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:54:53 -0800 (PST)
Message-ID: <a56f5bd7-92e1-48ec-9579-4b67dedb65b9@linaro.org>
Date: Mon, 29 Dec 2025 09:54:53 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 17/28] whpx: change memory management logic
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Zhao Liu <zhao1.liu@intel.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 kvm@vger.kernel.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, qemu-arm@nongnu.org,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
 <20251228235422.30383-18-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-18-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> This allows edk2 to work on Arm, although u-boot is still not functional.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   accel/whpx/whpx-common.c | 97 +++++++++++++++-------------------------
>   1 file changed, 36 insertions(+), 61 deletions(-)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


