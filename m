Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAA4724AA5
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 19:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbjFFRxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 13:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238841AbjFFRxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 13:53:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A595910F8
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 10:53:16 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356DDq88028710;
        Tue, 6 Jun 2023 17:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vSioZSU3J0WSf0ayVYNFzRIDmzAvF8MswtynjD+ke/I=;
 b=xuKaTdhHnPtP3HoFG6mw0GikCrtn+sGxsWKWlLugP4TqVAKKF+b5RSaJQtomGFoNJtV4
 R3dmWEDPuDO4hxV8Rw96ZwFpF42sXKstEtM6tsWzPpoubQzh4aSz2Sde0IQ7DluOOkrW
 YyuEe6izhRtCIlVWzMu2glPk9lru55dKVvua8z23FBjfuE6gl6/T85Stv++Dy4GD2mO/
 oOSlrlOJ0GBvzXfv7itdr+ybVZPLwGL19JM0vMa8pImaVOyF4KQDamaLl0SegeARKLUU
 W00b3q70Ui9mSyVaRYQ5TAAdnm4GKrRj+yy6wArh9ACLPTer7WwvFO2OgxAfnxwhbcUM tQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2c62y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 17:52:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 356GZtAd023861;
        Tue, 6 Jun 2023 17:52:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tq9hb2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 17:52:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Efz+eCn1bhS9c40mB67OqSEZVzDtpUjxOIJFBbtSW/urWEwEBYbmmKR5zrXJhjuAea75sNkMA+OjHPfx/WAMrkDES1IJflFDejJN1lfTnwwguQSiBpWh+iNgZCmlRrFABliMFxWgX9/3GKkQP7BMRRyLF1PuURHgY3L2Bbke8V49l7Z7XUNcS4vCPtdkiafetIMjtjQLkOxau+4O8Y3R9VeNr/Lb7L8r4qAShpf7BvFKVUks1WFvHNXJIx4OV29Wki9y1BG0T/ArL/KzpIr0LlqeYZy0GjDG7PGP8JGnJcydCigzzsZKB/I3xcRMRc1GWMbUrti1IDZN9O+qkLEYyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSioZSU3J0WSf0ayVYNFzRIDmzAvF8MswtynjD+ke/I=;
 b=jZ9lCJdTIl9Sa0sdg9RcSqWHb2cJTsB0tN2BsqMLxkfisdGdSti+p2TpFqmaiLv7Sm6KPMr4xJq/slWCcHmDiacutLq6WScaa8FIZBqwP6Pfkugkp6CesktQ3vidrijxLHfePRs174w86u7fo32CSNXnAOhQyzuzsbKHbNQB6xektNLHwcriqGdFSDATNVmJczDHLUth6x1Q1stuFIMvNDu89t00JtX7ocptVP7PS5HoostU7FABQ0IrDWvvYByJ0whRLV+hYs8nNIRH2b8yxx8k6AaEgVMyeUjDanQbtK62D09F6cmfste67DZ+VX2vF0dsoY7rS+pRA27n65GOmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSioZSU3J0WSf0ayVYNFzRIDmzAvF8MswtynjD+ke/I=;
 b=ZgK1fODxRaI5HQCg7gqw/X+JU+LgKxbhw5LDFrJ0/tqf1Vh8P0J4cAcrRv385ml0oZzx5HYMaXbuHy/RefHMXC8ImN1eg2ctGdhpoC4FE56DNQSodKDUvqaObQYSGurwPlDIm6GUFaQrLHKIYzN/RUeQK3gG9uKC4JaV6YgKYts=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DS7PR10MB4991.namprd10.prod.outlook.com (2603:10b6:5:38e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 17:52:30 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::7bf7:1f2d:e7d:bcae]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::7bf7:1f2d:e7d:bcae%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 17:52:29 +0000
From:   Miguel Luis <miguel.luis@oracle.com>
To:     Eric Auger <eauger@redhat.com>
CC:     Marc Zyngier <maz@kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Topic: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Index: AQHZh1MX+qQj9H8mMkuYpu12F27VUa9dHygAgAA8LwCAANHcgIAAV3oAgB8gkYCAAIteAA==
Date:   Tue, 6 Jun 2023 17:52:29 +0000
Message-ID: <054769EB-0722-45FB-8670-23CC7915AAA9@oracle.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <16d9fda4-3ead-7d5e-9f54-ef29fbd932ac@redhat.com>
 <87zg64nhqh.wl-maz@kernel.org>
 <d0b77823-c04c-4ee0-cb55-2cc20a48903b@redhat.com>
 <86r0rfkpwd.wl-maz@kernel.org>
 <bdcf630c-b6a7-0649-8419-15f98f6b1a0c@redhat.com>
In-Reply-To: <bdcf630c-b6a7-0649-8419-15f98f6b1a0c@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|DS7PR10MB4991:EE_
x-ms-office365-filtering-correlation-id: 935b81f0-ec1d-4a37-4754-08db66b6cc32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l/3d9LF/Rwk3yEaFRdjpStkg2Bg30/4mmpixRdd8J/EbZPDa5w1lSfZ30CYOCsxEcuO6wnO1zYPBYmqXd5aDtgEkX2FXkIDHyIHJ9w8SyqZzqRyeB4ZfdXaGleqrBPOQBTC6zQ28hvuMWREln2atV6YzSW4O8k3UfmdxUujwICN5QYuHGfmu8Mzj3CjdKu4qlq5R0JnrqolpqkcNRX0mg0+zPLoMl0G58Juv0f/oK9TkBDPmgYPs5ra3fbF1L+V7AqNVFFw52ZabuwvpsdbgMmvB0Wl9OTrmSKgd76nIO7dwKU+QNuvK/qEXC4nRkyIJ3EGRIa5wfdwe4O50xs0/S5f4gv+4uL3aFSDh8xbjCtJLCFonMHwLKTKRCUFjgkbwO/gkYxPe4T3Ae2AZHolfrSlwMIcL45d63L0BdWXDTndXelpTQi5H6hJNdBnje/gJxTI+7BeMBw1EcJ1slJOvH2CXZ7Aeiwd3R+2UgFdqEmdrpBamTB1MLI9IrDzjuoP08Mb43S092gPqYPgZBSzQSkK2G/8s/nJAVrE6lAPcCfDvUJkqymkEpXahiOGbqhmIVfE3v8+Frnq71vqVX4cTjYjbYTP00PPxJO3re8qsYuyf/z9m+1o+gtAFQjgRiI531nWatRrapoki639jDkILZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199021)(8676002)(4326008)(66446008)(76116006)(66556008)(6916009)(66476007)(64756008)(8936002)(91956017)(66946007)(5660300002)(7416002)(316002)(41300700001)(54906003)(44832011)(2906002)(478600001)(6486002)(122000001)(38100700002)(6512007)(53546011)(6506007)(86362001)(186003)(33656002)(71200400001)(36756003)(966005)(2616005)(83380400001)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFNMZ0tvaldoQlBtMUJEdEdDMWVad0E0Tm95bUNsbjR0M0x1Yk5DOVF1ME5V?=
 =?utf-8?B?cmpkUWJkRnJxUmZVQ2huY3VJTVhpaVpKYlNybjlXSkdDZ3lpU2ZTZlNJYVJN?=
 =?utf-8?B?ZGswR0hCNVJoWHJTNWd4Yk5udnZXdE1kRHYxLzJSb3p2allzOGpkaFZya3lK?=
 =?utf-8?B?MHhhRXRQU05Sb0Q2WnZSa2Q5bzRMRU0zdE1LZTVxOVVjcE5zVGhGYkNIUTdM?=
 =?utf-8?B?L0pCTExPUERjcGszbFNaWXlhc1dnYlV1anlMQlJJWkFzd2drL080bGNUY2xV?=
 =?utf-8?B?dXdNTTN5UHgwSlNZMVE4TkNmckpjU0V5ZWFNUlBRRjY0OGQrRUNqUXp1MFhS?=
 =?utf-8?B?RHlCRDZWMlk3UTFpa1A0a0hWaXBnYVpKdHdsVGFTZ0hNM0gwRldEKzRQK3FD?=
 =?utf-8?B?STMzaXpqWnVGVnFiaXlxQUFsaGFqdXlOVTdtQjNHZkNhbHVoZmpOOThrWXQ1?=
 =?utf-8?B?aGgrcGtBcW02YW9FU2M3Z0NvdHh5Q201dlJRSU5XUGJTRW5UZmk5ZlI2dUNF?=
 =?utf-8?B?citzd0ZWd2lzS005bnFsR0t0czRBbTdNVUROYmQ5NnNob2h3bVkxZnc0QWdz?=
 =?utf-8?B?SXRKb3NNemNTWlBPRUNTUFllbTdJWVpPMjQ2amNxckxpdFh3VC9GODM4S0lq?=
 =?utf-8?B?cXVyOTY5aG5uQ1pUS0tjaVJHSFB6RnFmWEFVNG85eWRMcWgydDRacU81TDFi?=
 =?utf-8?B?VDhZcmU4VU5oTzBlUmNndGNZamNzd0Jobjk2WUhNT3RMQnFLTXVMcXhMQ0Fq?=
 =?utf-8?B?L05RRkMrVkFtRVVMazFUZUxLUUx5d3ZCc1prMW1WcU9Ma0IvZnoyb29mY2xV?=
 =?utf-8?B?QVBxMm8xem1EUGFDRFpGUHcxWE0xcDQvc1g0WS80YXBTYVl5SE9vbFV0RjZw?=
 =?utf-8?B?U1dKSzhVUGRuS0szL3lGeGlhb29VRDZuNmp0SUxxK3ZTOFJZZ0twK0tYclJk?=
 =?utf-8?B?OXBkRkFjd2ljaTFmdXJ2UUlBSDdrQi9LNEsrM0Q4c1pOMUUrd3NCenUvWFNi?=
 =?utf-8?B?Z3FVQ3R1VTRUTHFwTDY4ckRaZlhsTXlpSThHOWdZRnhtazFIM0Q1Mjk2RjZX?=
 =?utf-8?B?TjdXL2ZWOWdSZDZaQ05sL0JSQzEzZHUzbkdTUjl1Z3VrS1lIRDBjbzMxSUJP?=
 =?utf-8?B?Zitzb2NjOHBmTzFjejZXTWIrcHQydm9kVUVKRVd4ZDN0dFFaUXQ4M0ZzTkpn?=
 =?utf-8?B?bW1BUWhHaktDZ3FkdlVjVnZ5NHY2dTZiRHNQQ0JxM0FnYVhFMHFibURjWURn?=
 =?utf-8?B?UDFBMFYraHVVMmpsTHRMSk9zRmtDOHZzZEd4c0RiT3E0RGxmTlJ4M1VzbVNU?=
 =?utf-8?B?dXVKT2l3c2JZSUdZNFJxWGJhTHNTb3Jnd08zbXJhb2RHV0RNWmJRLzBFSTZX?=
 =?utf-8?B?aTZrSFpuUDdRL1BRb3ZSNzNHQUZET1lHd0d0OEE4ZjNpT1BXZUVoQ1padEFD?=
 =?utf-8?B?Uk1SUSt6UDNkNzNEZGFXeFJhQ1dxUFdWUjdLYjZJQ2p0OE5CanJlUFJHUlhK?=
 =?utf-8?B?WVp1VmZvVFJnK1kyanFhdWhwcm0vakJ6aWpDNWl4NGFsODh3VTNQa2lWZGto?=
 =?utf-8?B?dTc0anFxb2R3Mk85emhEVFhoellUWFB1REg4czFrclZ5MERQTjFvWWFPSHAr?=
 =?utf-8?B?WlBkQ0ppTkVYVSt0amlxQWx2RmJIMlBDU2NUSjdIMUVxYmU2MEFVU3RGZERw?=
 =?utf-8?B?a285VUkvQUZIMzQvbzM3N2R1Ums2ZDg4YkRsVGRIWUlHNnpPM2pxZkphNzFK?=
 =?utf-8?B?VWhZN2VFSHJ1c1RvL3YrU2FKUUIzNndRTzZaSG40NEQ2bCtiTGdnMnRVY2w1?=
 =?utf-8?B?aGtRblNQRlNCM3FIalh3cHVJVGgyY0FwYkpKWkpoZ3RmMjYwdHFKTURLV1Jh?=
 =?utf-8?B?cS82K1FMUXBldTh1bGFWZnJmRFRmL0xBTytCTE1nSGI2Mnp3NU9yU25qNjV4?=
 =?utf-8?B?T1VKMXdkTUhsNUx6cWFWSmI2ajdlZ3pSV0pGSXJvdFZONmlFYW96WnA5Q1Jw?=
 =?utf-8?B?ZmZmYVRxSnp5N3kwS25Lc0JHNkdOMW9JYlBzT3J1TkMzRGZVTXlNL3R1eXdI?=
 =?utf-8?B?N0l6UHJ1QVNja25qVy85M2p1WUl1VVhqTFJBcjhvbklFNjgrRG5UZXFlYWxM?=
 =?utf-8?B?aU1kS2ZxV0puaTlZK3UzL2VGQVN6eE1tVGFMUi9ZM2dvOHFOcy9IS2pkYWEy?=
 =?utf-8?Q?lKESDQ0SRr37yYNY76RovqE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79D76CF81AD723418194B0927BC1357A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Q2E1bGdNS3ZsM0I2MnorUE5QN2RVTUgvSTNpTXpNTW5HTlk4eWxLMDFpMVcv?=
 =?utf-8?B?QWdGUVZwczZnc1RaYkNPTTZqVFRRQ2NpU0hia2VONTE3bm1zS1ZnSFRRYU43?=
 =?utf-8?B?Qk1jbkZKRGd5MXNnTndRTnJVMTNoL3NCMnJKZWN6QWpMa0xtY1F2Z2t3dzk3?=
 =?utf-8?B?TWVmRklHTDFWYjVsN29uYWowRmRES2k3bkR6Q2duZ3hkNE1JOU5IeGlYMjNo?=
 =?utf-8?B?Vjh0S21Id0RGVWJsRjk5Z0JzbVM1L3kvOTRkekRjRXhRUkNaR05iWFVHcTdN?=
 =?utf-8?B?RS9MZkkwcVl5MDNLM0lyajNxUGVRRUdjY2JKVU1JSXVKUG9mT1JZS1k2Y3VP?=
 =?utf-8?B?RWs1Tk8vQiszVUlpMHdMU2YrMDg0eDI4OENiWHMyQjBBd0JoZ3pyUjhMdWF2?=
 =?utf-8?B?Qk8vcmg2K2sxTnRFNnd2Z1NNcjRxanpyYkNjSCs1SVhSZ2gzaUpuK0R3QjUx?=
 =?utf-8?B?eFpNcnNPcmJJN2lKOGRyOVY4WnY2b3U2UXZyNVI2eVExQzdic1R1eUgxaEJw?=
 =?utf-8?B?bzVVNXZpRnRoSXdlbnoySXpNa2JKeU83U3ZkM2NNK2hoSnV1d0dONkV1ZnhE?=
 =?utf-8?B?cnpUZUJEZUNYZzdUM2V3MmJBNGx1UmpzV0NCSlA5cGxZcWpIZXIvZU9ETHlB?=
 =?utf-8?B?d1lJNWdGaUlZMmlUYWlXZWFzL2dleW9Bam5LL0lMeXBHN1FocnZLeUVGSG1N?=
 =?utf-8?B?OVc3Q2ZlM3UybzdSU0k3QkZsOVVmT1pVaHNXOS9Oa0pLQmdvUXBxcTZ3Nm1p?=
 =?utf-8?B?elVWSkFRQ2luLzg5QVFDcDA3RUsxTmp0S3lXRi9KdW0yelFBT212cVFEZ0FZ?=
 =?utf-8?B?dmlSSEhrcWYvUzUrL1NFQ1RpTVplN2ExcnRFUytjeVZUakc0bEQvTkpTejNS?=
 =?utf-8?B?eGJOaktnU0l6MWFxQ0MxNzVnS2ZWbU5qeWlENUtLa3doN1U2Z2tKRWVSaEsx?=
 =?utf-8?B?cms1d1UwYk1SaE1oSjhxeFQybFU5RHRzaXFxcVVCcVNyTUxXcW9WUDUydTJi?=
 =?utf-8?B?amdKRXhoMHpUUFZzWUJOTExoR2xoSFZCVzJSVEtXb2pWSmN6T3ZseEs1MXky?=
 =?utf-8?B?VU9QUmFaRW5qc0RCdmc5NTUwMEM1a2I4VGcwWFdkbFRkeW9qa3orZEdRd3Yy?=
 =?utf-8?B?RENrWEplMzRuMDhFUEppUGJwOFZRQXdkSDh6engza1J2bHA3dXRKelQxdVpU?=
 =?utf-8?B?NnA2ZldSMmdYeldBemFsNHBreVhxckpiSk8za0NyeWYrYUYzT1hBc3RuR1NM?=
 =?utf-8?B?VEJCSm1LWFYrajlXcC8rVTgvejRYQkk0YjVNZ25reE5McHV2VG9XQkxnS21z?=
 =?utf-8?B?RmZYS21MQWx6UUxrTHEyV1QrN252NWdtMlFiQXM2a0FIVjhMMXA2TGp3OUMr?=
 =?utf-8?B?bGIwbEpOV0x1TEV3Zmo2eFFZdGRubEY2YU9MRVRCTHM0clhDQS9nQ1dUQnpk?=
 =?utf-8?B?YUc1SXJDeHZnNTQrdDgwanczdVpmVFd1V0tEVmhBcklRQmUyY0lPUVFYeWdX?=
 =?utf-8?Q?i+GPLusKmWK0qhBfuzN956pXJCP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 935b81f0-ec1d-4a37-4754-08db66b6cc32
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 17:52:29.8438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kCE+77vum8r9PRm+ITEwo9+dDOO0AwydoTbOpsXvlEQaqeZAUYymGl+7KVH78CPocoO5Uq7NjtkjDuMYy5XeJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_12,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060153
X-Proofpoint-ORIG-GUID: xLjrVE7bV6ymf8lV7q9U6XaPA5Ti478l
X-Proofpoint-GUID: xLjrVE7bV6ymf8lV7q9U6XaPA5Ti478l
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGVsbG8gRXJpYywgTWFyYywNCg0KPiBPbiA2IEp1biAyMDIzLCBhdCAwOTozMywgRXJpYyBBdWdl
ciA8ZWF1Z2VyQHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gSGkgTWFyYywNCj4gDQo+IE9uIDUv
MTcvMjMgMTY6MTIsIE1hcmMgWnluZ2llciB3cm90ZToNCj4+IE9uIFdlZCwgMTcgTWF5IDIwMjMg
MDk6NTk6NDUgKzAxMDAsDQo+PiBFcmljIEF1Z2VyIDxlYXVnZXJAcmVkaGF0LmNvbT4gd3JvdGU6
DQo+Pj4gDQo+Pj4gSGkgTWFyYywNCj4+PiBIaSBNYXJjLA0KPj4+IE9uIDUvMTYvMjMgMjI6Mjgs
IE1hcmMgWnluZ2llciB3cm90ZToNCj4+Pj4gT24gVHVlLCAxNiBNYXkgMjAyMyAxNzo1MzoxNCAr
MDEwMCwNCj4+Pj4gRXJpYyBBdWdlciA8ZWF1Z2VyQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+Pj4g
DQo+Pj4+PiBIaSBNYXJjLA0KPj4+Pj4gDQo+Pj4+PiBPbiA1LzE1LzIzIDE5OjMwLCBNYXJjIFp5
bmdpZXIgd3JvdGU6DQo+Pj4+Pj4gVGhpcyBpcyB0aGUgNHRoIGRyb3Agb2YgTlYgc3VwcG9ydCBv
biBhcm02NCBmb3IgdGhpcyB5ZWFyLg0KPj4+Pj4+IA0KPj4+Pj4+IEZvciB0aGUgcHJldmlvdXMg
ZXBpc29kZXMsIHNlZSBbMV0uDQo+Pj4+Pj4gDQo+Pj4+Pj4gV2hhdCdzIGNoYW5nZWQ6DQo+Pj4+
Pj4gDQo+Pj4+Pj4gLSBOZXcgZnJhbWV3b3JrIHRvIHRyYWNrIHN5c3RlbSByZWdpc3RlciB0cmFw
cyB0aGF0IGFyZSByZWluamVjdGVkIGluDQo+Pj4+Pj4gIGd1ZXN0IEVMMi4gSXQgaXMgZXhwZWN0
ZWQgdG8gcmVwbGFjZSB0aGUgZGlzY3JldGUgaGFuZGxpbmcgd2UgaGF2ZQ0KPj4+Pj4+ICBlbmpv
eWVkIHNvIGZhciwgd2hpY2ggZGlkbid0IHNjYWxlIGF0IGFsbC4gVGhpcyBoYXMgYWxyZWFkeSBm
aXhlZCBhDQo+Pj4+Pj4gIG51bWJlciBvZiBidWdzIHRoYXQgd2VyZSBoaWRkZW4gKGEgYnVuY2gg
b2YgdHJhcHMgd2VyZSBuZXZlcg0KPj4+Pj4+ICBmb3J3YXJkZWQuLi4pLiBTdGlsbCBhIHdvcmsg
aW4gcHJvZ3Jlc3MsIGJ1dCB0aGlzIGlzIGdvaW5nIGluIHRoZQ0KPj4+Pj4+ICByaWdodCBkaXJl
Y3Rpb24uDQo+Pj4+Pj4gDQo+Pj4+Pj4gLSBBbGxvdyB0aGUgTDEgaHlwZXJ2aXNvciB0byBoYXZl
IGEgUzIgdGhhdCBoYXMgYW4gaW5wdXQgbGFyZ2VyIHRoYW4NCj4+Pj4+PiAgdGhlIEwwIElQQSBz
cGFjZS4gVGhpcyBmaXhlcyBhIG51bWJlciBvZiBzdWJ0bGUgaXNzdWVzLCBkZXBlbmRpbmcgb24N
Cj4+Pj4+PiAgaG93IHRoZSBpbml0aWFsIGd1ZXN0IHdhcyBjcmVhdGVkLg0KPj4+Pj4+IA0KPj4+
Pj4+IC0gQ29uc2VxdWVudGx5LCB0aGUgcGF0Y2ggc2VyaWVzIGhhcyBnb25lIGxvbmdlciBhZ2Fp
bi4gQm9vLiBCdXQNCj4+Pj4+PiAgaG9wZWZ1bGx5IHNvbWUgb2YgaXQgaXMgZWFzaWVyIHRvIHJl
dmlldy4uLg0KPj4+Pj4+IA0KPj4+Pj4+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIw
MjMwNDA1MTU0MDA4LjM1NTI4NTQtMS1tYXpAa2VybmVsLm9yZw0KPj4+Pj4gDQo+Pj4+PiBJIGhh
dmUgc3RhcnRlZCB0ZXN0aW5nIHRoaXMgYW5kIHdoZW4gYm9vdGluZyBteSBmZWRvcmEgZ3Vlc3Qg
SSBnZXQNCj4+Pj4+IA0KPj4+Pj4gWyAgMTUxLjc5NjU0NF0ga3ZtIFs3NjE3XTogVW5zdXBwb3J0
ZWQgZ3Vlc3Qgc3lzX3JlZyBhY2Nlc3MgYXQ6DQo+Pj4+PiAyM2Y0MjVmZDAgWzgwMDAwMjA5XQ0K
Pj4+Pj4gWyAgMTUxLjc5NjU0NF0gIHsgT3AwKCAzKSwgT3AxKCAzKSwgQ1JuKDE0KSwgQ1JtKCAz
KSwgT3AyKCAxKSwgZnVuY193cml0ZSB9LA0KPj4+Pj4gDQo+Pj4+PiBhcyBzb29uIGFzIHRoZSBo
b3N0IGhhcyBrdm0tYXJtLm1vZGU9bmVzdGVkDQo+Pj4+PiANCj4+Pj4+IFRoaXMgc2VlbXMgdG8g
YmUgdHJpZ2dlcmVkIHZlcnkgZWFybHkgYnkgRURLMg0KPj4+Pj4gKEFybVBrZy9Ecml2ZXJzL1Rp
bWVyRHhlL1RpbWVyRHhlLmMpLg0KPj4+Pj4gDQo+Pj4+PiBJZiBJIGFtIG5vdCB3cm9uZyB0aGlz
IENOVFZfQ1RMX0VMMC4gRG8geW91IGhhdmUgYW55IGlkZWE/DQo+Pj4+IA0KPj4+PiBTbyBoZXJl
J3MgbXkgY3VycmVudCBhbmFseXNpczoNCj4+Pj4gDQo+Pj4+IEkgYXNzdW1lIHlvdSBhcmUgcnVu
bmluZyBFREsyIGFzIHRoZSBMMSBndWVzdCBpbiBhIG5lc3RlZA0KPj4+PiBjb25maWd1cmF0aW9u
LiBJIGFsc28gYXNzdW1lIHRoYXQgeW91IGFyZSBub3QgcnVubmluZyBvbiBhbiBBcHBsZQ0KPj4+
PiBDUFUuIElmIHRoZXNlIGFzc3VtcHRpb25zIGFyZSBjb3JyZWN0LCB0aGVuIEVESzIgcnVucyBh
dCB2RUwyLCBhbmQgaXMNCj4+Pj4gaW4gblZIRSBtb2RlLg0KPj4+PiANCj4+Pj4gRmluYWxseSwg
SSdtIGdvaW5nIHRvIGFzc3VtZSB0aGF0IHlvdXIgaW1wbGVtZW50YXRpb24gaGFzIEZFQVRfRUNW
IGFuZA0KPj4+PiBGRUFUX05WMiwgYmVjYXVzZSBJIGNhbid0IHNlZSBob3cgaXQgY291bGQgZmFp
bCBvdGhlcndpc2UuDQo+Pj4gYWxsIHRoZSBhYm92ZSBpcyBjb3JyZWN0Lg0KPj4+PiANCj4+Pj4g
SW4gdGhlc2UgcHJlY2lzZSBjb25kaXRpb25zLCBLVk0gc2V0cyB0aGUgQ05USENUTF9FTDIuRUwx
VFZUIGJpdCBzbw0KPj4+PiB0aGF0IHdlIGNhbiB0cmFwIHRoZSBFTDAgdmlydHVhbCB0aW1lciBh
bmQgZmFpdGhmdWxseSBlbXVsYXRlIGl0IChpdA0KPj4+PiBpcyBvdGhlcndpc2Ugd3JpdHRlbiB0
byBtZW1vcnksIHdoaWNoIGlzbid0IHZlcnkgaGVscGZ1bCkuDQo+Pj4gDQo+Pj4gaW5kZWVkDQo+
Pj4+IA0KPj4+PiBBcyBpdCB0dXJucyBvdXQsIHdlIGRvbid0IGhhbmRsZSB0aGVzZSB0cmFwcy4g
SSBkaWRuJ3Qgc3BvdCBpdCBiZWNhdXNlDQo+Pj4+IG15IHRlc3QgbWFjaGluZXMgYXJlIGFsbCBB
cHBsZSBib3hlcyB0aGF0IGRvbid0IGhhdmUgYSBuVkhFIG1vZGUsIHNvDQo+Pj4+IG5vdGhpbmcg
b24gdGhlIG5WSEUgcGF0aCBpcyBnZXR0aW5nICpBTlkqIGNvdmVyYWdlLiBIaW50OiBoYXZpbmcN
Cj4+Pj4gYWNjZXNzIHRvIHN1Y2ggYSBtYWNoaW5lIHdvdWxkIGhlbHAgKHNoaXBwaW5nIGFkZHJl
c3Mgb24gcmVxdWVzdCEpLg0KPj4+PiBPdGhlcndpc2UsIEknbGwgZXZlbnR1YWxseSBraWxsIHRo
ZSBuVkhFIHN1cHBvcnQgYWx0b2dldGhlci4NCj4+Pj4gDQo+Pj4+IEkgaGF2ZSB3cml0dGVuIHRo
ZSBmb2xsb3dpbmcgcGF0Y2gsIHdoaWNoIGNvbXBpbGVzLCBidXQgdGhhdCBJIGNhbm5vdA0KPj4+
PiB0ZXN0IHdpdGggbXkgY3VycmVudCBzZXR1cC4gQ291bGQgeW91IHBsZWFzZSBnaXZlIGl0IGEg
Z28/DQo+Pj4gDQo+Pj4gd2l0aCB0aGUgcGF0Y2ggYmVsb3csIG15IGd1ZXN0IGJvb3RzIG5pY2Vs
eS4gWW91IGRpZCBpdCBncmVhdCBvbiB0aGUgMXN0DQo+Pj4gc2hvdCEhISBTbyB0aGlzIGZpeGVz
IG15IGlzc3VlLiBJIHdpbGwgY29udGludWUgdGVzdGluZyB0aGUgdjEwLg0KPj4gDQo+PiBUaGFu
a3MgYSBsb3QgZm9yIHJlcG9ydGluZyB0aGUgaXNzdWUgYW5kIHRlc3RpbmcgbXkgaGFja3MuIEkn
bGwNCj4+IGV2ZW50dWFsbHkgZm9sZCBpdCBpbnRvIHRoZSByZXN0IG9mIHRoZSBzZXJpZXMuDQo+
PiANCj4+IEJ5IHRoZSB3YXksIHdoYXQgYXJlIHlvdSB1c2luZyBhcyB5b3VyIFZNTT8gSSdkIHJl
YWxseSBsaWtlIHRvDQo+PiByZXByb2R1Y2UgeW91ciBzZXR1cC4NCj4gU29ycnkgSSBtaXNzZWQg
eW91ciByZXBseS4gSSBhbSB1c2luZyBsaWJ2aXJ0ICsgcWVtdSAoZmVhdCBNaWd1ZWwncyBSRkMp
DQo+IGFuZCBmZWRvcmEgTDEgZ3Vlc3QuDQo+IA0KDQpGb2xsb3dpbmcgdGhpcyBzdWJqZWN0LCBJ
4oCZdmUgZm9yd2FyZCBwb3J0ZWQgQWxleGFuZHJ14oCZcyBLVVQgcGF0Y2hlcw0KKCBhbmQgSSBl
bmNvdXJhZ2Ugb3RoZXJzIHRvIGRvIGl0IGFsc28gPSkgKSB3aGljaCBleHBvc2UgYW4gRUwyIHRl
c3QgdGhhdA0KZG9lcyB0aHJlZSBjaGVja3M6DQoNCi0gd2hldGhlciBWSEUgaXMgc3VwcG9ydGVk
IGFuZCBlbmFibGVkDQotIGRpc2FibGUgVkhFDQotIHJlLWVuYWJsZSBWSEUgIA0KDQpJ4oCZbSBy
dW5uaW5nIHFlbXUgd2l0aCB2aXJ0dWFsaXphdGlvbj1vbiBhcyB3ZWxsIHRvIHJ1biB0aGlzIHRl
c3QgYW5kIGl0IGlzIHBhc3NpbmcgYWx0aG91Z2gNCnByb2JsZW1zIHNlZW0gdG8gaGFwcGVuIHdo
ZW4gcnVubmluZyB3aXRoIHZpcnR1YWxpemF0aW9uPW9mZiwgd2hpY2ggSeKAmW0gc3RpbGwgbG9v
a2luZyBpbnRvIGl0Lg0KDQpUaGFua3MNCk1pZ3VlbA0KDQo+IFRoYW5rcyB0byB5b3VyIGZpeCwg
dGhpcyBib290cyBmaW5lLiBCdXQgYXQgdGhlIG1vbWVudCBpdCBkb2VzIG5vdA0KPiByZWJvb3Qg
YW5kIGhhbmdzIGluIGVkazIgSSB0aGluay4gVW5mb3J0dW5hdGVseSB0aGlzIHRpbWUgSSBoYXZl
IG5vDQo+IHRyYWNlIG9uIGhvc3QgOi0oIFdoaWxlIGxvb2tpbmcgYXQgeW91ciBzZXJpZXMgSSB3
aWxsIGFkZCBzb21lIHRyYWNlcy4NCj4gDQo+IEVyaWMNCj4+IA0KPj4gQ2hlZXJzLA0KPj4gDQo+
PiBNLg0KDQoNCg==
