Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADAF54B21D
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 15:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243256AbiFNNPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 09:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiFNNPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 09:15:47 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A043369FA
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 06:15:45 -0700 (PDT)
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25ECBwu3022614;
        Tue, 14 Jun 2022 13:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pps0720; bh=GiNLWfs0gfhB7BfKuY/Y2IQr5FdvAljcgEe93ZMfJjc=;
 b=XNXOBaYSEV9YG2hIW33+/dL8U3BmWdS/W6KBIRuVFlT5XPe+ZvGVuLM/gtGoVZtomTJ7
 NqjnXiGEYc8KiWNKb571DyAqWs7BRshJPAJIEjK+IvHtpLZukO6y6u4KGda1lx/ZnTV1
 3xpMBwu9JTwQY/v2ePpSzBS8s47f9QJH3a3jU3t4dfXxLtnalHub4gX/tZD/Wwx1bT4E
 +85eGCvBR9AhoqnSnvSqSGNHJtviKaZCieaduqV2wTxK4DyWONgGqiuHWKBQRFqv8Fjp
 7TzEKoNyMthYOloIeEb7iM2GXkD577mksOZPluE96G/5gmXVoIfH3tD6lXWmc+txwTbo zA== 
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3gpp98ax47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 13:14:54 +0000
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id B1FDF8058CE;
        Tue, 14 Jun 2022 13:14:51 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 14 Jun 2022 01:14:37 -1200
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 14 Jun 2022 01:14:36 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Tue, 14 Jun 2022 01:14:36 -1200
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 14 Jun 2022 01:14:36 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHYd6M1xI6xOW2Jc0Ju8e90VOLN9u4pXl5DDbF1oJU6iheAhm8YQqw8Z3sAgvklU2lig4FAx0TVfSWT57L2I7cSuOt+rwKLMuALJtmeKHUvF1faDeSvcxSIgavYT/NelamJWQlfQmxcTHrGb3sD4Ah6xJ7G/amOIQQ6Su+xNmVa6WJ0vJAMa2U/1nA800yBfWwIU4Xu/xd3KJH+e0l5sCh7H8Yzf7SQSYRN2SMdYYi6qAr8enGXic3xD3hjCHd1FdHOzkrB7Sb1Qnq4rn8kqQHfZMQNdWK0oLw25Xnvx28OBgdUR7FL1AYNTwAyLees7uDjvMu428B2/SZAfE2EzCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GiNLWfs0gfhB7BfKuY/Y2IQr5FdvAljcgEe93ZMfJjc=;
 b=AkdN2KhTR2mNtrYHxjL73AMLY5oQ+NVU0GebyaQ72CXR4WQGlZH0soQNVDHdAGA2QWqVLjIZPsvb/89ZN9j7pYNHhQJYDmva90gcpOpDUwBmmd9LI6EBE2xWFI0igYCfedG82plihpuYxlxpZO9NnF750n8h5TWDPGwZYCj6VvBgqsGZhDTocjTZxyZ7aFusewizIYfxYaMv//w0ZhM7aOcFf6dW8HMztB+vlhN/5Zr6vLWVy+FaaQZG9QsBWNz06TxU3o77CkFMyt1NWuorhfCTjILe5zacEQ6VR+VpxfnTqtMwJkhYTJPTDMJ3ezNoB1Ma+XWCdEYOfDfRoFDn3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c0::18)
 by MW5PR84MB1522.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.22; Tue, 14 Jun
 2022 13:14:35 +0000
Received: from MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::50dd:3941:8202:ea85]) by MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::50dd:3941:8202:ea85%9]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 13:14:35 +0000
From:   "Meyer, Kyle" <kyle.meyer@hpe.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>
CC:     kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Anderson, Russ" <russ.anderson@hpe.com>,
        "Payton, Brian" <payton@hpe.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Wahl, Steve" <steve.wahl@hpe.com>
Subject: Re: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 2048
Thread-Topic: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 2048
Thread-Index: AQHYf/CxIAUdSFI3GUOKlmcDPXzZOg==
Date:   Tue, 14 Jun 2022 13:14:35 +0000
Message-ID: <MW5PR84MB171345DE06867E18F25A9B109BAA9@MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6f10122-8f16-4990-b6ec-08da4e07d3f5
x-ms-traffictypediagnostic: MW5PR84MB1522:EE_
x-microsoft-antispam-prvs: <MW5PR84MB1522391736F5EB46AC6436DF9BAA9@MW5PR84MB1522.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nKGGdQHUNCFkKT4lzBhhwPTJCW/pb552ShSjguoYJ1KT3piNqKo+6HNSxuoNt5kqVUlFzC5ONY+C2DVla9vejPv+xpngO3X+vqDquTWzril0g3+TIbVLTtukjw+K2TE0IKAxLRP2ebWV0+oXWXbpyJJVgTKH3CYHS3swnjsq2RfkC9w9RHuWAmz98q1/UbmJsynAnK4N1giDxbsEQlR3JaMpCrVdM5i2tQNrR2dumus4OBhiVLmLcOA8X9fiDBaNYTDy+kY0JR92JliKpJoKKVlHRc5muCIz15G1z/m9FTULKbTtuG2ffPJxXN/BEQHA9QkkhYHaz+4FS1hIVhlxzAM+Ycfs63ChDqD/fDEmN4fzlm9+q5SxVun/Uj4vIv5ovalNYtuzU5jgrG8pE/AFyFJL6F5Hs/vXR3jbDfI9fvGDaXyc2JJrSrmZxia/ZBqoVzjgk0WWYkUdwXnGjBC+t2c00gFLbYK86IUBYcScjN6V+hS+eJD2+61Gzo0p5bh8T6ZMZBtjuW3+zDTW1CXMwlFQ9qnJeRezzhU9Dw14SSmvWavhTX2EUuOUR6ytf8JD3ON8poGHoZkXdv26ibg7j5S1Dzyu8C2L6eZpvmW3uLaRkJA/jIxNNVD5FqTkV9MsRm7EpcxEeuYEZqMz2EEgDP7/+jA+GtVdeWO87jts6ro0o78AGd0SF+yWYFvXUgU3KE9IcYsqsCetZ6hA+XxGZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(366004)(53546011)(86362001)(122000001)(6506007)(9686003)(71200400001)(38070700005)(7696005)(82960400001)(186003)(76116006)(7416002)(2906002)(52536014)(83380400001)(110136005)(54906003)(8936002)(4326008)(8676002)(64756008)(66446008)(91956017)(316002)(5660300002)(66476007)(66556008)(33656002)(66946007)(55016003)(508600001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?FK33O5LnI9p3o6dZjZyb22zHJqzus4D1LrEQc2PaAb2SzV/6gJoG0d6a2w?=
 =?iso-8859-1?Q?zZhcPxl2lsxUHOgRyjCvGakpDyOahvBYgIofYFgMUbSoHNBM22GMUVDJYW?=
 =?iso-8859-1?Q?opaNlRaPebOPAcI3smf+rL/wEhKxhaNgN2AICia1fq9wB0Q+8oWFda2pVd?=
 =?iso-8859-1?Q?FkUbyGsacAxzFDqe5DDEFMKz+vcIKpSYnnCOLP5PtGiFUp3LgqVOAbON6Z?=
 =?iso-8859-1?Q?YKItQt3/0m+ULjyl5Mvg3azjTyJgk2pAfwYxj2uMb97t80V5lzQV4x3bs+?=
 =?iso-8859-1?Q?t6oHjO7+xkmnkXCeki6Vz6sPGb+rcOOHK3IqM4urm8oRQ2VCf4BnF816R9?=
 =?iso-8859-1?Q?9FTlPeosuf8o49x17oZq8cmiyKKp9+nSEekFHGX045lhsURcga1+3NXEHY?=
 =?iso-8859-1?Q?Nck+9fMAH4GRtscrZxn7LplOTqU7jkHz4aKfQx2G+wfD7FiyyHpiXK18ty?=
 =?iso-8859-1?Q?B3IOSb1lUs+f0FTqgJuUdS2Kl+toeRkRaRYgEc9Y+jKc/wV01AFgi6kpkn?=
 =?iso-8859-1?Q?+oU4DHjlrf9RQ77Wui4JaXXnpO0u0rMtOX61VochiTmH68R2BNUnFKlo4d?=
 =?iso-8859-1?Q?hfTlBVLQrjaK3Jciv2gkXqc7myIbj70a20DpWCZWRzyzrdnhg6v8ipujkE?=
 =?iso-8859-1?Q?ISFuADOUz+gJpoVs6Ooqj1Y1ARGS/u766vrC49tvwLbnqFA4zUUdi/7UeC?=
 =?iso-8859-1?Q?dun8mrLP+J8bnz6m4A4tBogrf0JtAI30bGwQbyGToFcrufWtcfdHxRIUZG?=
 =?iso-8859-1?Q?+tm2wMnwsYnX39UaHonxShGhrzDRFsLUMJCoRS22DcttSagzzKvB0c0tlv?=
 =?iso-8859-1?Q?Sh/xJQJBq10hXoP8uLlBvaFCl4NR/iSERnRHn/gSAh5JxIJQ4fCg/R21uz?=
 =?iso-8859-1?Q?GkGBcEbsCCRiZo0MLEACB/4y6hnew2ZQuhT+x8xauUuJmXDGYEkLtesFmS?=
 =?iso-8859-1?Q?r0ci40lbrzauwAprbprgeF+DmaLfOYVDNmgfYUEHBEr5lbi36eqCdJMy2/?=
 =?iso-8859-1?Q?4WgC/e0iVTU9RxXGNMwRQBN/aNFm1yxB4vZGBXVsnyfZL5mtHNiJLmTEDi?=
 =?iso-8859-1?Q?YOPS2qNuHQM/1oR79mOHz0tg/aVWd4bz1iy4f9qLps8+Sf6Ntmr9U1mJsd?=
 =?iso-8859-1?Q?UVclw2imN9tO8yhJAqqfj2gOg2/VbuxczZqye5yR0X4bKdt4lKJ3A2/r0j?=
 =?iso-8859-1?Q?cYGUPtMigJh+4KjmL90JSY4qAGgAhBo5prm5we+kqq+z0y71keEPn9CoZX?=
 =?iso-8859-1?Q?Ta6Og4ho+a8uuG5HObG7nzECx1biZHiNuxfxQCF51TQAmHnHVq9NGWfYfE?=
 =?iso-8859-1?Q?YXsIBwxyD958xEoHy/qeT32tKJ8UBG8MfSQX7Q9tLBgCp4mypGU9jyqT94?=
 =?iso-8859-1?Q?yFuUtaMGYPu76CPC/fQYPJmx81hB0SeWulieRifS4xHSoLy6lM5oUEBZ+F?=
 =?iso-8859-1?Q?t7ffb8nMdcfA1/5X0hkRaLT/4NOQyA2do/irhnmIhbcx5EiIa1P4Kj4SNa?=
 =?iso-8859-1?Q?vQ1vBdGvWpzC4idSXjHyAWQOJS+01NmMtLBpQrZSkZOWQJNK5mG4vo/fw5?=
 =?iso-8859-1?Q?HnYJuhjdYkrYGQw9J4S9jOAUX00+Cge4H0IJZOd5KgfpwXaEp+Q0aB9MVk?=
 =?iso-8859-1?Q?ZIYYWzQDkJ/GlZpduNJT6M//Dbv5C1hRhYGieRl5ow+TtmJ1YiGoNApX4X?=
 =?iso-8859-1?Q?ESDlZrM/GxW6UsFwkyZLDu3nojBDmrwpHh8+KiW1pLCaGy4g58j6VL53eL?=
 =?iso-8859-1?Q?vQ3zFIH3A3tv2kcGVdKBb5I+v7G1uDFa9myfhUBWZPen81i8e/1D+atFaU?=
 =?iso-8859-1?Q?Ux99yNlrc1KkrFpNF0mSkAHqKvaUc/B3NMZRcwTdZV/BvM5hKS0+qd9nma?=
 =?iso-8859-1?Q?9X?=
x-ms-exchange-antispam-messagedata-1: Uf+GnxV6qsi3Sg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f10122-8f16-4990-b6ec-08da4e07d3f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 13:14:35.3711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7xoOyVN7P0ytmmHsosjdk+8T18bmhy//xZ8hZccYwdMk6u+ZvA14XIbFZQ9V+nPeLx3aEjjSZ3Sr9CxHo5cxWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR84MB1522
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: j3e7FmYIZBGxjdsMgcmgLJy8X78xPnRV
X-Proofpoint-ORIG-GUID: j3e7FmYIZBGxjdsMgcmgLJy8X78xPnRV
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_04,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206140053
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > Increase KVM_MAX_VCPUS to 2048 so we can run larger virtual machines.
> >
> > Does the host machine have 2048 CPUs (or more) as well in your usecase?

No, the largest system that I've used had 1792 CPUs.

> > I'm wondering if it makes sense to start configuring KVM_MAX_VCPUS
> > based on NR_CPUS. That way KVM can scale up on large machines without
> > using more memory on small machines.
> >
> > e.g.
> >
> > /* Provide backwards compatibility. */
> > #if NR_CPUS < 1024
> >   #define KVM_MAX_VCPUS 1024
> > #else
> >   #define KVM_MAX_VCPUS NR_CPUS
> > #endif
> >
> > The only downside I can see for this approach is if you are trying to
> > kick the tires a new large VM on a smaller host because the new "large
> > host" hardware hasn't landed yet.
>
> FWIW, while I don't think there's anything wrong with such approach, it
> won't help much distro kernels which are not recompiled to meet the
> needs of a particular host. According to Kyle's numbers, the biggest
> growth is observed with 'struct kvm_ioapic' and that's only because of
> 'struct rtc_status' embedded in it. Maybe it's possible to use something
> different from a KVM_MAX_VCPU_IDS-bound flat bitmask there? I'm not sure
> how important this is as it's just another 4K per-VM and when guest's
> memory is taken into account it's probably not much.
>
> The growth in 'struct kvm'/'struct kvm_arch' seems to be insignificant
> and on-stack allocations are probably OK.

If NR_CPUS is used, KVM_MAX_VCPUS will be 8192 and KVM_MAX_VCPU_IDS will be
32768 when MAXSMP is set.

Thanks,
Kyle Meyer

________________________________________
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Sent: Tuesday, June 14, 2022 3:27 AM
To: David Matlack; Meyer, Kyle
Cc: kvm list; X86 ML; Borislav Petkov; Dave Hansen; Ingo Molnar; Thomas Gle=
ixner; Anderson, Russ; Payton, Brian; H. Peter Anvin; Jim Mattson; Joerg Ro=
edel; Sean Christopherson; Wanpeng Li
Subject: Re: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 2048

David Matlack <dmatlack@google.com> writes:

> On Mon, Jun 13, 2022 at 11:35 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
>>
>> Increase KVM_MAX_VCPUS to 2048 so we can run larger virtual machines.
>
> Does the host machine have 2048 CPUs (or more) as well in your usecase?
>
> I'm wondering if it makes sense to start configuring KVM_MAX_VCPUS
> based on NR_CPUS. That way KVM can scale up on large machines without
> using more memory on small machines.
>
> e.g.
>
> /* Provide backwards compatibility. */
> #if NR_CPUS < 1024
>   #define KVM_MAX_VCPUS 1024
> #else
>   #define KVM_MAX_VCPUS NR_CPUS
> #endif
>
> The only downside I can see for this approach is if you are trying to
> kick the tires a new large VM on a smaller host because the new "large
> host" hardware hasn't landed yet.

FWIW, while I don't think there's anything wrong with such approach, it
won't help much distro kernels which are not recompiled to meet the
needs of a particular host. According to Kyle's numbers, the biggest
growth is observed with 'struct kvm_ioapic' and that's only because of
'struct rtc_status' embedded in it. Maybe it's possible to use something
different from a KVM_MAX_VCPU_IDS-bound flat bitmask there? I'm not sure
how important this is as it's just another 4K per-VM and when guest's
memory is taken into account it's probably not much.

The growth in 'struct kvm'/'struct kvm_arch' seems to be insignificant
and on-stack allocations are probably OK.

--
Vitaly

