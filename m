Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007542860E2
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 16:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgJGOFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 10:05:09 -0400
Received: from loire.is.ed.ac.uk ([129.215.16.10]:38896 "EHLO
        loire.is.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbgJGOFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 10:05:08 -0400
Received: from exseed.ed.ac.uk (hbdat3.is.ed.ac.uk [129.215.235.38])
        by loire.is.ed.ac.uk (8.14.7/8.14.7) with ESMTP id 097E4uii020153
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 7 Oct 2020 15:04:56 +0100
Received: from hbdkb3.is.ed.ac.uk (129.215.235.37) by hbdat3.is.ed.ac.uk
 (129.215.235.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 7 Oct 2020
 15:04:56 +0100
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (104.47.17.108)
 by hbdkb3.is.ed.ac.uk (129.215.235.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 7 Oct 2020 15:04:55 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fu4AW0hWNJnY++BiXl87X4rOZX9FLH2hPH9trm4+YixgyjRq2tSBL36JfOt1Whme8/i8YoK4MY35BKU9CVrjfEzQvu5BDPCFqG++e442JfL57g9tU/NlIcHBc2cfkoYwali18kDPdjSTF1d137r+HKf7omzMqUSdhvuP4mfLAf6zP6hFOdpXx30dhlwS/hWM3uHjS3LfD9fN4wKHlIqD2mr7sDHKHKBnEy3/gVPWr/8l+4Quur9gQlhZSSBjxVv21VLeCf5ukJwhRvQsplvNn/Uco1Z60LeEuwyj4kAXNvUkLldFc+11nYfd+LtS40jIL2aKgQJUuNsdb7EOpCm6vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjYWRCodAghEJW93D79+8oMhhbnHdbMawyYuzM9oCII=;
 b=eYpV6YC01CEcG4jktpLi2yCbh68YhyjgxqUuet44IYG8qtuoWUWWX7AENZs7zwb0WQfGeiIA02vx/36Q7p0R2ipyr3uJ7vj50LkEYoP4FcFxNqFDgLYQZrCI7sdp3wTMMHxQIDh0pnHIwg0vSZ/LqD7BzBunade575RSbcTe8IhEXgRSg9lggjxavbJkegwZHQSLUWqJikr+WvLRO4rXEXbx9qUXEMELMirektROi2yoxfZ2rrKikuJC1nnEpDALiCv7vWsaZsIjWlqw1KhIZdLYjDvpcfw7ltziw5hWiaUYkHC0rHsLGZUY6l+IKsSskv+BjPENeVcrJu/RkFKbPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ed.ac.uk; dmarc=pass action=none header.from=ed.ac.uk;
 dkim=pass header.d=ed.ac.uk; arc=none
Received: from AM7PR05MB7076.eurprd05.prod.outlook.com (2603:10a6:20b:1af::19)
 by AM5PR0501MB2418.eurprd05.prod.outlook.com (2603:10a6:203:9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Wed, 7 Oct
 2020 14:04:55 +0000
Received: from AM7PR05MB7076.eurprd05.prod.outlook.com
 ([fe80::c9af:88a9:6fef:7b63]) by AM7PR05MB7076.eurprd05.prod.outlook.com
 ([fe80::c9af:88a9:6fef:7b63%5]) with mapi id 15.20.3433.045; Wed, 7 Oct 2020
 14:04:55 +0000
From:   BARBALACE Antonio <antonio.barbalace@ed.ac.uk>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "will@kernel.org" <will@kernel.org>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: kvmtool: vhost MQ support
Thread-Topic: kvmtool: vhost MQ support
Thread-Index: AdabPziwTOUsNiurQESVfC61e3LkNAAmMWQAADaea8A=
Date:   Wed, 7 Oct 2020 14:04:54 +0000
Message-ID: <AM7PR05MB7076C2EED57761B346BCB17FCC0A0@AM7PR05MB7076.eurprd05.prod.outlook.com>
References: <AM7PR05MB7076F55498C85087F09421F6CC0C0@AM7PR05MB7076.eurprd05.prod.outlook.com>
 <87a6wz8t27.fsf@vitty.brq.redhat.com>
In-Reply-To: <87a6wz8t27.fsf@vitty.brq.redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=ed.ac.uk;
x-originating-ip: [82.38.204.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bf4d837-8e8a-4a1b-d666-08d86ac9f7be
x-ms-traffictypediagnostic: AM5PR0501MB2418:
x-microsoft-antispam-prvs: <AM5PR0501MB241821CC4DB164DDD29EA6F1CC0A0@AM5PR0501MB2418.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iqGPZytAJVpdVI3gJO/NpoJeH7Fw17WDJEPjMwpqfNO1blti6B/DM0CrARwwuUAd2NVhWOlVizPIKdAy9pv4a7tyk3zHElFknypzByn0Qmf5GjI5CqQA2smLmhNJ+MkawQ7t6Sfaau1LoLR7YJLB76oYJCHSyvZX0YPOq9LzkAQOCoax69jdUm9jnpw0TrPJwTjW/bUh7wTFe4KMB76b4wYJ3beJxSSLEYAILoUkDHHPby7SDfz8CV4brv7MPElNd0qkdEJ0ZPNj/JT8Fst/QWUj9+FLOz3Xu8iQicFkh7m+3RZF6VnR0Z9/Rsc0uyO9mVs+2CaSeV75zt95tK2h7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7076.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(39860400002)(376002)(4326008)(9686003)(86362001)(83380400001)(2906002)(99936003)(478600001)(6916009)(26005)(54906003)(7696005)(55016002)(66616009)(64756008)(76116006)(66556008)(66476007)(66446008)(66946007)(8936002)(186003)(6506007)(53546011)(5660300002)(316002)(52536014)(71200400001)(33656002)(8676002)(786003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3fYLD57Z7/2uv3fSN2J+pj8O5gNqotJXJ9OaQS9pDvvULN39ZimlCncO7t1digi635nSnneKg1aChkcgqE0JvIPuQW39A+R+nx5Zuuz8SUtH5xnGrd9sY7G5RN+xoGoEp9YwL8iKvkxEVahYSEGOBaYqGlnF0+4BX3yuGUqf3dOgdKbwOauhEh1Or7sDqcJgZvA69pDHcCXUeGPvFcRRp7yl5j9vQ32xnKu5QF5lOCnDofr7U8oHgbHIJMvP2ZherO0KwXIpmi515fEU396fW9Aw18ewzgQsS64HxjQ99Ow91n4lzV1cvhPfO5fOKF26a8d4YJyNyo/DGrPyj4QU042NRMlNBRYNVcBF/1fJqI/kow7os5Tagr7t1ffNEzJ1YIdVFpyvKZ3glu5J1EQOiNOY/vbYTxZxwTBxzYLQ3R5L9Cf1hcwTDWHS0G7DnjkncFVPigJtcu63otPSCUZF6q6+BTukeuHdt/H1Lrpnw4R3sjhbw9krWdtDGTRUTe3X2fbn42tZYkpwmidAxY10hkOQhjjZomwMv/aT3pf4RMwscBX1dMIsDP+Qj3DZb1txDZcaAtINgEIUmDiIKbrozGkaTZq5jw0CAljXynjwwieT31kCj6rfF6df+EMvSGd5wjIiw8TIX5c1xDtwqJnrjQ==
x-ms-exchange-transport-forked: True
Content-Type: multipart/mixed;
        boundary="_002_AM7PR05MB7076C2EED57761B346BCB17FCC0A0AM7PR05MB7076eurp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR05MB7076.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf4d837-8e8a-4a1b-d666-08d86ac9f7be
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 14:04:54.9498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e9f06b0-1669-4589-8789-10a06934dc61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pmxqo18H6ShrgrMohhuGCKZ3wNoiyhzvVxRsTqjjC7N69/AOEgoRzvuGGQbSMCFitN9YqEs2NMZ8QYJ9kU4SBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0501MB2418
X-OriginatorOrg: ed.ac.uk
X-Edinburgh-Scanned: at loire.is.ed.ac.uk
    with MIMEDefang 2.84, Sophie, Sophos Anti-Virus, Clam AntiVirus
X-Scanned-By: MIMEDefang 2.84 on 129.215.16.10
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--_002_AM7PR05MB7076C2EED57761B346BCB17FCC0A0AM7PR05MB7076eurp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Vitaly,
 Thanks for your quick feedback, sorry for the several formatting issues! I=
 applied all your comments to the attached patch.
 For the moment, I would prefer to keep 'vhost_fd', but happy to remove it =
if you would like me to do so -- just let me know.
Cheers,
Antonio

-----Original Message-----
From: Vitaly Kuznetsov <vkuznets@redhat.com>=20
Sent: Tuesday, October 6, 2020 12:58 PM
To: BARBALACE Antonio <antonio.barbalace@ed.ac.uk>
Cc: will@kernel.org; julien.thierry.kdev@gmail.com; kvm@vger.kernel.org
Subject: Re: kvmtool: vhost MQ support

BARBALACE Antonio <antonio.barbalace@ed.ac.uk> writes:

> This patch enables vhost MQ to support in kvmtool without any Linux kerne=
l modification.
> The patch takes the same approach as QEMU -- for each queue pair a new /d=
ev/vhost-net fd is created.
> Fds are kept in ndev->vhost_fds, with ndev->vhost_fd =3D=3D ndev->vhost_f=
ds[0] (to avoid further modification to the existent source code).
> Thanks, Antonio Barbalace
> The University of Edinburgh is a charitable body, registered in Scotland,=
 with registration number SC005336.
> diff --git a/virtio/net.c b/virtio/net.c index 1ee3c19..bae3019 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -58,6 +58,7 @@ struct net_dev {
>  	u32				features, queue_pairs;
> =20
>  	int				vhost_fd;
> +	int				vhost_fds[VIRTIO_NET_NUM_QUEUES];
>  	int				tap_fd;
>  	char				tap_name[IFNAMSIZ];
>  	bool				tap_ufo;
> @@ -512,6 +513,7 @@ static int virtio_net__vhost_set_features(struct=20
> net_dev *ndev)  {
>  	u64 features =3D 1UL << VIRTIO_RING_F_EVENT_IDX;
>  	u64 vhost_features;
> +	int i, r =3D 0;
> =20
>  	if (ioctl(ndev->vhost_fd, VHOST_GET_FEATURES, &vhost_features) !=3D 0)
>  		die_perror("VHOST_GET_FEATURES failed"); @@ -521,7 +523,9 @@ static=20
> int virtio_net__vhost_set_features(struct net_dev *ndev)
>  			has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF))
>  		features |=3D 1UL << VIRTIO_NET_F_MRG_RXBUF;
> =20
> -	return ioctl(ndev->vhost_fd, VHOST_SET_FEATURES, &features);
> +	for (i=3D0; ((u32)i < ndev->queue_pairs) && (r >=3D 0); i++)

Neither a virtio nor a kvmtool person here, just some comments about the st=
yle below.

Nit: more spaces needed:
	for (i =3D 0;=20

(u32) cast is not really needed because ndev->queue_pairs is caped with VIR=
TIO_NET_NUM_QUEUES and=20

ndev->queue_pairs =3D max(1, min(VIRTIO_NET_NUM_QUEUES, params->mq));

alternatively, you can just declare i as 'u32'.

> +		r =3D ioctl(ndev->vhost_fds[i], VHOST_SET_FEATURES, &features);

To improve the readability I'd suggest to write this as

	for (i=3D0; i < ndev->queue_pairs; i++) {
		r =3D ioctl(ndev->vhost_fds[i], VHOST_SET_FEATURES, &features);
		if (r)
			break;
	}


> +	return r;
>  }
> =20
>  static void set_guest_features(struct kvm *kvm, void *dev, u32=20
> features) @@ -578,7 +582,7 @@ static bool is_ctrl_vq(struct net_dev=20
> *ndev, u32 vq)  static int init_vq(struct kvm *kvm, void *dev, u32 vq, u3=
2 page_size, u32 align,
>  		   u32 pfn)
>  {
> -	struct vhost_vring_state state =3D { .index =3D vq };
> +	struct vhost_vring_state state =3D { .index =3D (vq %2) };

Nit: superfluous parentheses

>  	struct net_dev_queue *net_queue;
>  	struct vhost_vring_addr addr;
>  	struct net_dev *ndev =3D dev;
> @@ -619,23 +623,24 @@ static int init_vq(struct kvm *kvm, void *dev, u32 =
vq, u32 page_size, u32 align,
>  	if (queue->endian !=3D VIRTIO_ENDIAN_HOST)
>  		die_perror("VHOST requires the same endianness in guest and host");
> =20
> -	state.num =3D queue->vring.num;
> -	r =3D ioctl(ndev->vhost_fd, VHOST_SET_VRING_NUM, &state);
> +	state.num =3D queue->vring.num; //number of decriptors

I don't see C++ style comments anywhere in this file, use /* */ instead.

> +        r =3D ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_NUM,=20
> + &state);

Indentation. Also, you seem to be using 'vq / 2' a lot, maybe assign this t=
o a local variable.

>  	if (r < 0)
>  		die_perror("VHOST_SET_VRING_NUM failed");
> -	state.num =3D 0;
> -	r =3D ioctl(ndev->vhost_fd, VHOST_SET_VRING_BASE, &state);
> +
> +	state.num =3D 0; //descriptors base

Comment style.

> +	r =3D ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_BASE, &state);
>  	if (r < 0)
>  		die_perror("VHOST_SET_VRING_BASE failed");
> =20
>  	addr =3D (struct vhost_vring_addr) {
> -		.index =3D vq,
> +		.index =3D (vq %2),
>  		.desc_user_addr =3D (u64)(unsigned long)queue->vring.desc,
>  		.avail_user_addr =3D (u64)(unsigned long)queue->vring.avail,
>  		.used_user_addr =3D (u64)(unsigned long)queue->vring.used,
>  	};
> =20
> -	r =3D ioctl(ndev->vhost_fd, VHOST_SET_VRING_ADDR, &addr);
> +	r =3D ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_ADDR, &addr);
>  	if (r < 0)
>  		die_perror("VHOST_SET_VRING_ADDR failed");
> =20
> @@ -659,7 +664,7 @@ static void exit_vq(struct kvm *kvm, void *dev, u32 v=
q)
>  	 */
>  	if (ndev->vhost_fd && !is_ctrl_vq(ndev, vq)) {
>  		pr_warning("Cannot reset VHOST queue");
> -		ioctl(ndev->vhost_fd, VHOST_RESET_OWNER);
> +		ioctl(ndev->vhost_fds[(vq /2)], VHOST_RESET_OWNER);
>  		return;
>  	}
> =20
> @@ -682,7 +687,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev,=
 u32 vq, u32 gsi)
>  		return;
> =20
>  	file =3D (struct vhost_vring_file) {
> -		.index	=3D vq,
> +		.index	=3D (vq % 2),
>  		.fd	=3D eventfd(0, 0),
>  	};
> =20
> @@ -693,31 +698,32 @@ static void notify_vq_gsi(struct kvm *kvm, void *de=
v, u32 vq, u32 gsi)
>  	queue->irqfd =3D file.fd;
>  	queue->gsi =3D gsi;
> =20
> -	r =3D ioctl(ndev->vhost_fd, VHOST_SET_VRING_CALL, &file);
> +	r =3D ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_CALL, &file);
>  	if (r < 0)
>  		die_perror("VHOST_SET_VRING_CALL failed");
> +
>  	file.fd =3D ndev->tap_fd;
> -	r =3D ioctl(ndev->vhost_fd, VHOST_NET_SET_BACKEND, &file);
> +	r =3D ioctl(ndev->vhost_fds[(vq /2)], VHOST_NET_SET_BACKEND, &file);
>  	if (r !=3D 0)
>  		die("VHOST_NET_SET_BACKEND failed %d", errno);
> -
>  }
> =20
>  static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32=20
> efd)  {
>  	struct net_dev *ndev =3D dev;
>  	struct vhost_vring_file file =3D {
> -		.index	=3D vq,
> +		.index	=3D (vq % 2),
>  		.fd	=3D efd,
>  	};
>  	int r;
> =20
> -	if (ndev->vhost_fd =3D=3D 0 || is_ctrl_vq(ndev, vq))
> +	if (ndev->vhost_fd =3D=3D 0 || is_ctrl_vq(ndev, vq)) {
>  		return;
> +	}
> +	r =3D ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_KICK, &file);
> =20
> -	r =3D ioctl(ndev->vhost_fd, VHOST_SET_VRING_KICK, &file);
>  	if (r < 0)
> -		die_perror("VHOST_SET_VRING_KICK failed");
> +		die_perror("VHOST_SET_VRING_KICK failed test");

What is this 'failed test' about? Stray change?

>  }
> =20
>  static int notify_vq(struct kvm *kvm, void *dev, u32 vq) @@ -777,10=20
> +783,6 @@ static void virtio_net__vhost_init(struct kvm *kvm, struct net_=
dev *ndev)
>  	struct vhost_memory *mem;
>  	int r, i;
> =20
> -	ndev->vhost_fd =3D open("/dev/vhost-net", O_RDWR);
> -	if (ndev->vhost_fd < 0)
> -		die_perror("Failed openning vhost-net device");
> -
>  	mem =3D calloc(1, sizeof(*mem) + kvm->mem_slots * sizeof(struct vhost_m=
emory_region));
>  	if (mem =3D=3D NULL)
>  		die("Failed allocating memory for vhost memory map"); @@ -796,13=20
> +798,22 @@ static void virtio_net__vhost_init(struct kvm *kvm, struct net=
_dev *ndev)
>  	}
>  	mem->nregions =3D i;
> =20
> -	r =3D ioctl(ndev->vhost_fd, VHOST_SET_OWNER);
> -	if (r !=3D 0)
> -		die_perror("VHOST_SET_OWNER failed");
> +	for (i=3D0; ((u32)i < ndev->queue_pairs) &&=20
> +			(i < VIRTIO_NET_NUM_QUEUES); i++) {
> =20

Same as above.

> -	r =3D ioctl(ndev->vhost_fd, VHOST_SET_MEM_TABLE, mem);
> -	if (r !=3D 0)
> -		die_perror("VHOST_SET_MEM_TABLE failed");
> +		ndev->vhost_fds[i] =3D open("/dev/vhost-net", O_RDWR);
> +	        if (ndev->vhost_fds[i] < 0)
> +			die_perror("Failed openning vhost-net device");
> +
> +		r =3D ioctl(ndev->vhost_fds[i], VHOST_SET_OWNER);
> +		if (r !=3D 0)
> +			die_perror("VHOST_SET_OWNER failed");
> +=09
> +		r =3D ioctl(ndev->vhost_fds[i], VHOST_SET_MEM_TABLE, mem);
> +		if (r !=3D 0)
> +			die_perror("VHOST_SET_MEM_TABLE failed");
> +	}
> +	ndev->vhost_fd =3D ndev->vhost_fds[0];

Do we actually need 'vhost_fd' at all, can we just use vhost_fds[0] in a fe=
w places where it is still present?

> =20
>  	ndev->vdev.use_vhost =3D true;
> =20
> @@ -966,7 +977,6 @@ static int virtio_net__init_one(struct virtio_net_par=
ams *params)
>  				   "falling back to %s.", params->trans,
>  				   virtio_trans_name(trans));
>  	}
> -

Stray change?

>  	r =3D virtio_init(params->kvm, ndev, &ndev->vdev, ops, trans,
>  			PCI_DEVICE_ID_VIRTIO_NET, VIRTIO_ID_NET, PCI_CLASS_NET);
>  	if (r < 0) {
> diff --git a/virtio/pci.c b/virtio/pci.c index c652949..7a1532b 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -44,7 +44,8 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, =
struct virtio_device *vde
>  	 * Vhost will poll the eventfd in host kernel side, otherwise we
>  	 * need to poll in userspace.
>  	 */
> -	if (!vdev->use_vhost)
> +	if ( (!vdev->use_vhost) ||

Xen coding style detected :-) Just

	if (!vdev->use_vhost || (vdev->ops->get_vq_count(kvm, vpci->dev) =3D vq + =
1)

would do fine.

> +		((u32)vdev->ops->get_vq_count(kvm, vpci->dev)=3D=3D(vq+1)) )
>  		flags |=3D IOEVENTFD_FLAG_USER_POLL;
> =20
>  	/* ioport */

--
Vitaly


--_002_AM7PR05MB7076C2EED57761B346BCB17FCC0A0AM7PR05MB7076eurp_
Content-Type: application/octet-stream; name="kvmtool-vhost_mq-20201007.patch"
Content-Description: kvmtool-vhost_mq-20201007.patch
Content-Disposition: attachment; filename="kvmtool-vhost_mq-20201007.patch";
	size=6057; creation-date="Wed, 07 Oct 2020 14:04:00 GMT";
	modification-date="Wed, 07 Oct 2020 14:04:00 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL3ZpcnRpby9uZXQuYyBiL3ZpcnRpby9uZXQuYwppbmRleCAxZWUzYzE5Li5h
Y2RkNzQxIDEwMDY0NAotLS0gYS92aXJ0aW8vbmV0LmMKKysrIGIvdmlydGlvL25ldC5jCkBAIC01
OCw2ICs1OCw3IEBAIHN0cnVjdCBuZXRfZGV2IHsKIAl1MzIJCQkJZmVhdHVyZXMsIHF1ZXVlX3Bh
aXJzOwogCiAJaW50CQkJCXZob3N0X2ZkOworCWludAkJCQl2aG9zdF9mZHNbVklSVElPX05FVF9O
VU1fUVVFVUVTXTsKIAlpbnQJCQkJdGFwX2ZkOwogCWNoYXIJCQkJdGFwX25hbWVbSUZOQU1TSVpd
OwogCWJvb2wJCQkJdGFwX3VmbzsKQEAgLTUxMiw2ICs1MTMsOCBAQCBzdGF0aWMgaW50IHZpcnRp
b19uZXRfX3Zob3N0X3NldF9mZWF0dXJlcyhzdHJ1Y3QgbmV0X2RldiAqbmRldikKIHsKIAl1NjQg
ZmVhdHVyZXMgPSAxVUwgPDwgVklSVElPX1JJTkdfRl9FVkVOVF9JRFg7CiAJdTY0IHZob3N0X2Zl
YXR1cmVzOworCXUzMiBpOworCWludCByID0gMDsKIAogCWlmIChpb2N0bChuZGV2LT52aG9zdF9m
ZCwgVkhPU1RfR0VUX0ZFQVRVUkVTLCAmdmhvc3RfZmVhdHVyZXMpICE9IDApCiAJCWRpZV9wZXJy
b3IoIlZIT1NUX0dFVF9GRUFUVVJFUyBmYWlsZWQiKTsKQEAgLTUyMSw3ICs1MjQsMTMgQEAgc3Rh
dGljIGludCB2aXJ0aW9fbmV0X192aG9zdF9zZXRfZmVhdHVyZXMoc3RydWN0IG5ldF9kZXYgKm5k
ZXYpCiAJCQloYXNfdmlydGlvX2ZlYXR1cmUobmRldiwgVklSVElPX05FVF9GX01SR19SWEJVRikp
CiAJCWZlYXR1cmVzIHw9IDFVTCA8PCBWSVJUSU9fTkVUX0ZfTVJHX1JYQlVGOwogCi0JcmV0dXJu
IGlvY3RsKG5kZXYtPnZob3N0X2ZkLCBWSE9TVF9TRVRfRkVBVFVSRVMsICZmZWF0dXJlcyk7CisJ
Zm9yIChpID0gMCA7IGkgPCBuZGV2LT5xdWV1ZV9wYWlycyA7IGkrKykgeworCQlyID0gaW9jdGwo
bmRldi0+dmhvc3RfZmRzW2ldLCBWSE9TVF9TRVRfRkVBVFVSRVMsICZmZWF0dXJlcyk7IAorCQlp
ZiAociA8IDApCisJCQlicmVhazsKKwl9CisKKwlyZXR1cm4gcjsKIH0KIAogc3RhdGljIHZvaWQg
c2V0X2d1ZXN0X2ZlYXR1cmVzKHN0cnVjdCBrdm0gKmt2bSwgdm9pZCAqZGV2LCB1MzIgZmVhdHVy
ZXMpCkBAIC01NzgsMTMgKzU4NywxMyBAQCBzdGF0aWMgYm9vbCBpc19jdHJsX3ZxKHN0cnVjdCBu
ZXRfZGV2ICpuZGV2LCB1MzIgdnEpCiBzdGF0aWMgaW50IGluaXRfdnEoc3RydWN0IGt2bSAqa3Zt
LCB2b2lkICpkZXYsIHUzMiB2cSwgdTMyIHBhZ2Vfc2l6ZSwgdTMyIGFsaWduLAogCQkgICB1MzIg
cGZuKQogewotCXN0cnVjdCB2aG9zdF92cmluZ19zdGF0ZSBzdGF0ZSA9IHsgLmluZGV4ID0gdnEg
fTsKKwlzdHJ1Y3Qgdmhvc3RfdnJpbmdfc3RhdGUgc3RhdGUgPSB7IC5pbmRleCA9IHZxICUgMiB9
OwogCXN0cnVjdCBuZXRfZGV2X3F1ZXVlICpuZXRfcXVldWU7CiAJc3RydWN0IHZob3N0X3ZyaW5n
X2FkZHIgYWRkcjsKIAlzdHJ1Y3QgbmV0X2RldiAqbmRldiA9IGRldjsKIAlzdHJ1Y3QgdmlydF9x
dWV1ZSAqcXVldWU7CiAJdm9pZCAqcDsKLQlpbnQgcjsKKwlpbnQgciwgdnFfZmQgPSB2cSAvIDI7
CiAKIAljb21wYXRfX3JlbW92ZV9tZXNzYWdlKGNvbXBhdF9pZCk7CiAKQEAgLTYxOSwyMyArNjI4
LDI0IEBAIHN0YXRpYyBpbnQgaW5pdF92cShzdHJ1Y3Qga3ZtICprdm0sIHZvaWQgKmRldiwgdTMy
IHZxLCB1MzIgcGFnZV9zaXplLCB1MzIgYWxpZ24sCiAJaWYgKHF1ZXVlLT5lbmRpYW4gIT0gVklS
VElPX0VORElBTl9IT1NUKQogCQlkaWVfcGVycm9yKCJWSE9TVCByZXF1aXJlcyB0aGUgc2FtZSBl
bmRpYW5uZXNzIGluIGd1ZXN0IGFuZCBob3N0Iik7CiAKLQlzdGF0ZS5udW0gPSBxdWV1ZS0+dnJp
bmcubnVtOwotCXIgPSBpb2N0bChuZGV2LT52aG9zdF9mZCwgVkhPU1RfU0VUX1ZSSU5HX05VTSwg
JnN0YXRlKTsKKwlzdGF0ZS5udW0gPSBxdWV1ZS0+dnJpbmcubnVtOyAKKwlyID0gaW9jdGwobmRl
di0+dmhvc3RfZmRzW3ZxX2ZkXSwgVkhPU1RfU0VUX1ZSSU5HX05VTSwgJnN0YXRlKTsKIAlpZiAo
ciA8IDApCiAJCWRpZV9wZXJyb3IoIlZIT1NUX1NFVF9WUklOR19OVU0gZmFpbGVkIik7CisKIAlz
dGF0ZS5udW0gPSAwOwotCXIgPSBpb2N0bChuZGV2LT52aG9zdF9mZCwgVkhPU1RfU0VUX1ZSSU5H
X0JBU0UsICZzdGF0ZSk7CisJciA9IGlvY3RsKG5kZXYtPnZob3N0X2Zkc1t2cV9mZF0sIFZIT1NU
X1NFVF9WUklOR19CQVNFLCAmc3RhdGUpOwogCWlmIChyIDwgMCkKIAkJZGllX3BlcnJvcigiVkhP
U1RfU0VUX1ZSSU5HX0JBU0UgZmFpbGVkIik7CiAKIAlhZGRyID0gKHN0cnVjdCB2aG9zdF92cmlu
Z19hZGRyKSB7Ci0JCS5pbmRleCA9IHZxLAorCQkuaW5kZXggPSB2cSAlIDIsCiAJCS5kZXNjX3Vz
ZXJfYWRkciA9ICh1NjQpKHVuc2lnbmVkIGxvbmcpcXVldWUtPnZyaW5nLmRlc2MsCiAJCS5hdmFp
bF91c2VyX2FkZHIgPSAodTY0KSh1bnNpZ25lZCBsb25nKXF1ZXVlLT52cmluZy5hdmFpbCwKIAkJ
LnVzZWRfdXNlcl9hZGRyID0gKHU2NCkodW5zaWduZWQgbG9uZylxdWV1ZS0+dnJpbmcudXNlZCwK
IAl9OwogCi0JciA9IGlvY3RsKG5kZXYtPnZob3N0X2ZkLCBWSE9TVF9TRVRfVlJJTkdfQUREUiwg
JmFkZHIpOworCXIgPSBpb2N0bChuZGV2LT52aG9zdF9mZHNbdnFfZmRdLCBWSE9TVF9TRVRfVlJJ
TkdfQUREUiwgJmFkZHIpOwogCWlmIChyIDwgMCkKIAkJZGllX3BlcnJvcigiVkhPU1RfU0VUX1ZS
SU5HX0FERFIgZmFpbGVkIik7CiAKQEAgLTY1OSw3ICs2NjksNyBAQCBzdGF0aWMgdm9pZCBleGl0
X3ZxKHN0cnVjdCBrdm0gKmt2bSwgdm9pZCAqZGV2LCB1MzIgdnEpCiAJICovCiAJaWYgKG5kZXYt
PnZob3N0X2ZkICYmICFpc19jdHJsX3ZxKG5kZXYsIHZxKSkgewogCQlwcl93YXJuaW5nKCJDYW5u
b3QgcmVzZXQgVkhPU1QgcXVldWUiKTsKLQkJaW9jdGwobmRldi0+dmhvc3RfZmQsIFZIT1NUX1JF
U0VUX09XTkVSKTsKKwkJaW9jdGwobmRldi0+dmhvc3RfZmRzWyh2cSAvMildLCBWSE9TVF9SRVNF
VF9PV05FUik7CiAJCXJldHVybjsKIAl9CiAKQEAgLTY4Miw3ICs2OTIsNyBAQCBzdGF0aWMgdm9p
ZCBub3RpZnlfdnFfZ3NpKHN0cnVjdCBrdm0gKmt2bSwgdm9pZCAqZGV2LCB1MzIgdnEsIHUzMiBn
c2kpCiAJCXJldHVybjsKIAogCWZpbGUgPSAoc3RydWN0IHZob3N0X3ZyaW5nX2ZpbGUpIHsKLQkJ
LmluZGV4CT0gdnEsCisJCS5pbmRleAk9IHZxICUgMiwKIAkJLmZkCT0gZXZlbnRmZCgwLCAwKSwK
IAl9OwogCkBAIC02OTMsMjkgKzcwMywzMCBAQCBzdGF0aWMgdm9pZCBub3RpZnlfdnFfZ3NpKHN0
cnVjdCBrdm0gKmt2bSwgdm9pZCAqZGV2LCB1MzIgdnEsIHUzMiBnc2kpCiAJcXVldWUtPmlycWZk
ID0gZmlsZS5mZDsKIAlxdWV1ZS0+Z3NpID0gZ3NpOwogCi0JciA9IGlvY3RsKG5kZXYtPnZob3N0
X2ZkLCBWSE9TVF9TRVRfVlJJTkdfQ0FMTCwgJmZpbGUpOworCXIgPSBpb2N0bChuZGV2LT52aG9z
dF9mZHNbKHZxIC8yKV0sIFZIT1NUX1NFVF9WUklOR19DQUxMLCAmZmlsZSk7CiAJaWYgKHIgPCAw
KQogCQlkaWVfcGVycm9yKCJWSE9TVF9TRVRfVlJJTkdfQ0FMTCBmYWlsZWQiKTsKKwogCWZpbGUu
ZmQgPSBuZGV2LT50YXBfZmQ7Ci0JciA9IGlvY3RsKG5kZXYtPnZob3N0X2ZkLCBWSE9TVF9ORVRf
U0VUX0JBQ0tFTkQsICZmaWxlKTsKKwlyID0gaW9jdGwobmRldi0+dmhvc3RfZmRzWyh2cSAvMild
LCBWSE9TVF9ORVRfU0VUX0JBQ0tFTkQsICZmaWxlKTsKIAlpZiAociAhPSAwKQogCQlkaWUoIlZI
T1NUX05FVF9TRVRfQkFDS0VORCBmYWlsZWQgJWQiLCBlcnJubyk7Ci0KIH0KIAogc3RhdGljIHZv
aWQgbm90aWZ5X3ZxX2V2ZW50ZmQoc3RydWN0IGt2bSAqa3ZtLCB2b2lkICpkZXYsIHUzMiB2cSwg
dTMyIGVmZCkKIHsKIAlzdHJ1Y3QgbmV0X2RldiAqbmRldiA9IGRldjsKIAlzdHJ1Y3Qgdmhvc3Rf
dnJpbmdfZmlsZSBmaWxlID0gewotCQkuaW5kZXgJPSB2cSwKKwkJLmluZGV4CT0gdnEgJSAyLAog
CQkuZmQJPSBlZmQsCiAJfTsKIAlpbnQgcjsKIAotCWlmIChuZGV2LT52aG9zdF9mZCA9PSAwIHx8
IGlzX2N0cmxfdnEobmRldiwgdnEpKQorCWlmIChuZGV2LT52aG9zdF9mZCA9PSAwIHx8IGlzX2N0
cmxfdnEobmRldiwgdnEpKSB7CiAJCXJldHVybjsKKwl9CisJciA9IGlvY3RsKG5kZXYtPnZob3N0
X2Zkc1sodnEgLzIpXSwgVkhPU1RfU0VUX1ZSSU5HX0tJQ0ssICZmaWxlKTsKIAotCXIgPSBpb2N0
bChuZGV2LT52aG9zdF9mZCwgVkhPU1RfU0VUX1ZSSU5HX0tJQ0ssICZmaWxlKTsKIAlpZiAociA8
IDApCiAJCWRpZV9wZXJyb3IoIlZIT1NUX1NFVF9WUklOR19LSUNLIGZhaWxlZCIpOwogfQpAQCAt
Nzc3LDEwICs3ODgsNiBAQCBzdGF0aWMgdm9pZCB2aXJ0aW9fbmV0X192aG9zdF9pbml0KHN0cnVj
dCBrdm0gKmt2bSwgc3RydWN0IG5ldF9kZXYgKm5kZXYpCiAJc3RydWN0IHZob3N0X21lbW9yeSAq
bWVtOwogCWludCByLCBpOwogCi0JbmRldi0+dmhvc3RfZmQgPSBvcGVuKCIvZGV2L3Zob3N0LW5l
dCIsIE9fUkRXUik7Ci0JaWYgKG5kZXYtPnZob3N0X2ZkIDwgMCkKLQkJZGllX3BlcnJvcigiRmFp
bGVkIG9wZW5uaW5nIHZob3N0LW5ldCBkZXZpY2UiKTsKLQogCW1lbSA9IGNhbGxvYygxLCBzaXpl
b2YoKm1lbSkgKyBrdm0tPm1lbV9zbG90cyAqIHNpemVvZihzdHJ1Y3Qgdmhvc3RfbWVtb3J5X3Jl
Z2lvbikpOwogCWlmIChtZW0gPT0gTlVMTCkKIAkJZGllKCJGYWlsZWQgYWxsb2NhdGluZyBtZW1v
cnkgZm9yIHZob3N0IG1lbW9yeSBtYXAiKTsKQEAgLTc5NiwxMyArODAzLDIyIEBAIHN0YXRpYyB2
b2lkIHZpcnRpb19uZXRfX3Zob3N0X2luaXQoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3QgbmV0X2Rl
diAqbmRldikKIAl9CiAJbWVtLT5ucmVnaW9ucyA9IGk7CiAKLQlyID0gaW9jdGwobmRldi0+dmhv
c3RfZmQsIFZIT1NUX1NFVF9PV05FUik7Ci0JaWYgKHIgIT0gMCkKLQkJZGllX3BlcnJvcigiVkhP
U1RfU0VUX09XTkVSIGZhaWxlZCIpOworCWZvciAoaSA9IDAgOyAoaSA8IChpbnQpbmRldi0+cXVl
dWVfcGFpcnMpICYmIAorCQkJKGkgPCBWSVJUSU9fTkVUX05VTV9RVUVVRVMpIDsgaSsrKSB7CiAK
LQlyID0gaW9jdGwobmRldi0+dmhvc3RfZmQsIFZIT1NUX1NFVF9NRU1fVEFCTEUsIG1lbSk7Ci0J
aWYgKHIgIT0gMCkKLQkJZGllX3BlcnJvcigiVkhPU1RfU0VUX01FTV9UQUJMRSBmYWlsZWQiKTsK
KwkJbmRldi0+dmhvc3RfZmRzW2ldID0gb3BlbigiL2Rldi92aG9zdC1uZXQiLCBPX1JEV1IpOwor
CQlpZiAobmRldi0+dmhvc3RfZmRzW2ldIDwgMCkKKwkJCWRpZV9wZXJyb3IoIkZhaWxlZCBvcGVu
bmluZyB2aG9zdC1uZXQgZGV2aWNlIik7CisKKwkJciA9IGlvY3RsKG5kZXYtPnZob3N0X2Zkc1tp
XSwgVkhPU1RfU0VUX09XTkVSKTsKKwkJaWYgKHIgIT0gMCkKKwkJCWRpZV9wZXJyb3IoIlZIT1NU
X1NFVF9PV05FUiBmYWlsZWQiKTsKKwkKKwkJciA9IGlvY3RsKG5kZXYtPnZob3N0X2Zkc1tpXSwg
VkhPU1RfU0VUX01FTV9UQUJMRSwgbWVtKTsKKwkJaWYgKHIgIT0gMCkKKwkJCWRpZV9wZXJyb3Io
IlZIT1NUX1NFVF9NRU1fVEFCTEUgZmFpbGVkIik7CisJfQorCW5kZXYtPnZob3N0X2ZkID0gbmRl
di0+dmhvc3RfZmRzWzBdOwogCiAJbmRldi0+dmRldi51c2Vfdmhvc3QgPSB0cnVlOwogCmRpZmYg
LS1naXQgYS92aXJ0aW8vcGNpLmMgYi92aXJ0aW8vcGNpLmMKaW5kZXggYzY1Mjk0OS4uMmM0NTZk
ZiAxMDA2NDQKLS0tIGEvdmlydGlvL3BjaS5jCisrKyBiL3ZpcnRpby9wY2kuYwpAQCAtNDQsNyAr
NDQsNyBAQCBzdGF0aWMgaW50IHZpcnRpb19wY2lfX2luaXRfaW9ldmVudGZkKHN0cnVjdCBrdm0g
Kmt2bSwgc3RydWN0IHZpcnRpb19kZXZpY2UgKnZkZQogCSAqIFZob3N0IHdpbGwgcG9sbCB0aGUg
ZXZlbnRmZCBpbiBob3N0IGtlcm5lbCBzaWRlLCBvdGhlcndpc2Ugd2UKIAkgKiBuZWVkIHRvIHBv
bGwgaW4gdXNlcnNwYWNlLgogCSAqLwotCWlmICghdmRldi0+dXNlX3Zob3N0KQorCWlmICghdmRl
di0+dXNlX3Zob3N0IHx8ICh2ZGV2LT5vcHMtPmdldF92cV9jb3VudChrdm0sIHZwY2ktPmRldikg
PT0gKGludCl2cSArIDEpKQogCQlmbGFncyB8PSBJT0VWRU5URkRfRkxBR19VU0VSX1BPTEw7CiAK
IAkvKiBpb3BvcnQgKi8K

--_002_AM7PR05MB7076C2EED57761B346BCB17FCC0A0AM7PR05MB7076eurp_--
