Return-Path: <kvm+bounces-52629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 154CEB0753A
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 14:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABD095683F5
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5E22F4316;
	Wed, 16 Jul 2025 12:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="r0QJjZ2z"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7342F2736
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 12:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752667248; cv=none; b=NkqrtWk7ihmTU34pBHjzXWhL5/boGW99HpfqiVePwnK/MnRtHr8Sjas8oXiIRfbokfWKMjC/201/K7zsKMVkEC2uZzf4BnzPHC5TJ1eLOOdWvPE6VCfY1htUOERpa+rdkYMmGbH9XA1A1/KlQrjE9r31j0ohjxZohNFd4watEoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752667248; c=relaxed/simple;
	bh=mMu5WZFj3zRO+OxdWgkTHxUKkUA2GR/T9tn2vDi3jI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pIjzLH+kUIXNGcJqkstFcQa23in/EnOa/W824K05zAl0AERQzqRrd1rDJepCaFZQiEM2ichg6/oA9MovxUo4glmrw4nhn3U/UGLtVYd8we9VRonwdSlMgBBrQd8hh7+h9tucpcyrDC/HqhvlXvgltvNoUss+hajuTM3Km5AAmH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=r0QJjZ2z reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [157.82.206.39] ([157.82.206.39])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 56GC0iQM034126
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 16 Jul 2025 21:00:44 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=DUA9zl7P8Tu6TlT+ueMdR11qSW4yTfnVp0swAEHI/jQ=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1752667245; v=1;
        b=r0QJjZ2zldg5upfbmdV0xlKdIRFSCo46g8rvFdC6ZqbhkIZ4W6f5oixA1Ej1rS4D
         3Pxc3ZU4hugUbGXYOC81Uow6nm85VbUQowSjLl5q/Y/MeiklcviWe58Hb5y2JgkA
         1yG0ZUCUrmeASrQC0cE4pHWssBTHVtVfB0q0kWtJc7EwLQVQDPuOlHkFVpZQ7hMi
         UilgRZ5ZlHLoXMhUdTi0Qxw2sj6eTVao2lg3Vm8/+h3qKekI3wEjNs68fXGxvV+I
         GHHv9BSYbmUuTu/K68sbByjCR7PsUdvy9QljiqiSM2AJ2Bl/YSZpt56OrDHbBx4M
         dFOnnmTxJLGpDEu3b3k96Q==
Message-ID: <c1c64a05-49c3-45b3-bb8a-8fc075e57286@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 16 Jul 2025 21:00:44 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 08/13] qmp: update virtio features map to support
 extended features
To: Paolo Abeni <pabeni@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Jason Wang
 <jasowang@redhat.com>,
        Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Luigi Rizzo <lrizzo@google.com>,
        Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>,
        Vincenzo Maffione <v.maffione@gmail.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <5f5a6718fa5ae82d5cd3b73523deea41089ffeb5.1752229731.git.pabeni@redhat.com>
 <aab8c434-364e-4305-9d8b-943eb0c98406@rsg.ci.i.u-tokyo.ac.jp>
 <b0ff2033-b8ab-4cee-833c-83e70951a9d9@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <b0ff2033-b8ab-4cee-833c-83e70951a9d9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/07/16 0:43, Paolo Abeni wrote:
> On 7/15/25 9:59 AM, Akihiko Odaki wrote:
>> On 2025/07/11 22:02, Paolo Abeni wrote:
>>> @@ -785,11 +821,12 @@ VirtioStatus *qmp_x_query_virtio_status(const char *path, Error **errp)
>>>            status->vhost_dev->nvqs = hdev->nvqs;
>>>            status->vhost_dev->vq_index = hdev->vq_index;
>>>            status->vhost_dev->features =
>>> -            qmp_decode_features(vdev->device_id, hdev->features);
>>> +            qmp_decode_features(vdev->device_id, hdev->features_array);
>>>            status->vhost_dev->acked_features =
>>> -            qmp_decode_features(vdev->device_id, hdev->acked_features);
>>> +            qmp_decode_features(vdev->device_id, hdev->acked_features_array);
>>>            status->vhost_dev->backend_features =
>>> -            qmp_decode_features(vdev->device_id, hdev->backend_features);
>>> +            qmp_decode_features(vdev->device_id, hdev->backend_features_array);
>>> +
>>>            status->vhost_dev->protocol_features =
>>>                qmp_decode_protocols(hdev->protocol_features);
>>>            status->vhost_dev->max_queues = hdev->max_queues;
>>> diff --git a/hw/virtio/virtio-qmp.h b/hw/virtio/virtio-qmp.h
>>> index 245a446a56..e0a1e49035 100644
>>> --- a/hw/virtio/virtio-qmp.h
>>> +++ b/hw/virtio/virtio-qmp.h
>>> @@ -18,6 +18,7 @@
>>>    VirtIODevice *qmp_find_virtio_device(const char *path);
>>>    VirtioDeviceStatus *qmp_decode_status(uint8_t bitmap);
>>>    VhostDeviceProtocols *qmp_decode_protocols(uint64_t bitmap);
>>> -VirtioDeviceFeatures *qmp_decode_features(uint16_t device_id, uint64_t bitmap);
>>> +VirtioDeviceFeatures *qmp_decode_features(uint16_t device_id,
>>> +                                          const uint64_t *bitmap);
>>>    
>>>    #endif
>>> diff --git a/qapi/virtio.json b/qapi/virtio.json
>>> index 73df718a26..f0442e144b 100644
>>> --- a/qapi/virtio.json
>>> +++ b/qapi/virtio.json
>>> @@ -488,14 +488,18 @@
>>>    #     unique features)
>>>    #
>>>    # @unknown-dev-features: Virtio device features bitmap that have not
>>> -#     been decoded
>>> +#     been decoded (lower 64 bit)
>>> +#
>>> +# @unknown-dev-features-dword2: Virtio device features bitmap that have not
>>> +#     been decoded (bits 65-128)
>>>    #
>>>    # Since: 7.2
>>>    ##
>>>    { 'struct': 'VirtioDeviceFeatures',
>>>      'data': { 'transports': [ 'str' ],
>>>                '*dev-features': [ 'str' ],
>>> -            '*unknown-dev-features': 'uint64' } }
>>> +            '*unknown-dev-features': 'uint64',
>>> +            '*unknown-dev-features-dword2': 'uint64' } }
>>
>> Let's omit "dword" for consistency with unknown-dev-features, which is
>> also uint64 but don't have the keyword.
> 
> Ok. Can I infer that is actually legit to update a qapi struct
> definition? It's not clear to me it such change violates any qemu
> assumptions.

Adding a property is fine but renaming one is not as it can break 
application that use QAPI such as libvirt. For some guidance, please 
see: docs/devel/qapi-code-gen.rst

