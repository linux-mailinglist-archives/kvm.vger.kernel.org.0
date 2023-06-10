Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F35C72AA3C
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 10:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjFJI1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jun 2023 04:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjFJI1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jun 2023 04:27:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2AB210E
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 01:26:59 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35A69J8m012293;
        Sat, 10 Jun 2023 08:25:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=MIGq23tv4QMPu56jD4Mu2IWc2aw3kSb/3M0usdNgFqk=;
 b=kZmlTQswfA8dSSCclKLD9M4C99n2TdHOK6G6a9YZBqRtILUUu+BJMr9o3wBde4S4p85S
 EJ2/jKI7PYF5jqWjC2URs3g/xApTAiNKxIvI02zVehY/TJGKX92aeeyvWHpHM+wqLXaX
 RJnIIbcldIP3yU/T7ChJddAySF9w/82mzyKWb2s15zAYyPYqW3WaNI+j26C282+dYguk
 VNU9YDqZjVGxEaCaaLmRaoQVlINhYfqA+yYRb3Xy8MqUWhCEf3Vmejv8B8iPHBxv9QgJ
 MwAGf5FVIv3rOt1d/sv4neGrDttmHuu1TwA+LW7+RXX88AFSdd9xVYoWfxwfOekZlpTG Cw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4gstr994-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Jun 2023 08:25:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35A6DSdb008377;
        Sat, 10 Jun 2023 08:25:53 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm7e7rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Jun 2023 08:25:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yj8ceu4jkqqF106a3yfmYDxu3M+Nk6STTDk4Qxb7TgHTeRgiEynmuZ2ncq4e6otHAM3/Hk8R4AhgsUoclFGQ5J+qyKqBh9DKcKzJECc9uPQXCTxzEfck9OMQ1gWYj9M5JnXgfEMJUYid9jIcKuyh1l22dg4b/PUE36WdzZfMeFKgm4ky1Wg1Zt6Yx7FK3W5IcTqBY2jVpj0gQhgeCVhQJ5bZTq7ehus7RnuRYwpK7ja9y39GnJjwV+HOVfcnV7g2ZH+kxEAkWGrIAQiDXdndqiQIbmEXFeE1CwF6Oir+cimuUxWlbzLz2x+nK9TlszCJivBjIx6sV13Gb4+BlwbldQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIGq23tv4QMPu56jD4Mu2IWc2aw3kSb/3M0usdNgFqk=;
 b=OKfO/orHEXCSCL2lkGBmPrn4JBdm+TDYMjUKvCTinTXWvq5HyTT8/hX5pTzXLEmlt6cezN9QW/phDESFeWl5T8JSUXd4Vr5KLiyp9vMLg2dhYjUqh9YVJqo3WIsZe3U1qa03avtNBug5iwfcyIdbphjZIfs0HYhZWnJvv82rP4V46O0XJkQ89aYMuQrpO2xYwCS/X8C4ATlcavZmzN1SAujDAHDTyPtpAN7Sai+dXYG9fHDbecfXcBgtpyD3gpRyQ9MUMGYggvluAxBwrTwRl1MhvIc97a7q8LLo2J70zzMeA5cDEes9Cnai4hT9mysQPTxM1mlPm7H9PFqmxc5t/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIGq23tv4QMPu56jD4Mu2IWc2aw3kSb/3M0usdNgFqk=;
 b=yoFziN6aa8GP2hHtaP+ysmksUOUerq5cPbAJKu+jq96da+xHBPqaREKTX6LGUb+IvOFvDk8QT17oC9f/zlmm21h3fWpbdWAUctD3TXJOE/zVFkhXDrdadP65EG5Va4MXJFa3uLG09v91nAOLY0/X785BPj4n2YpRT3i6UwDt6rs=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DS7PR10MB5182.namprd10.prod.outlook.com (2603:10b6:5:38f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Sat, 10 Jun
 2023 08:25:51 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::7bf7:1f2d:e7d:bcae]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::7bf7:1f2d:e7d:bcae%4]) with mapi id 15.20.6455.030; Sat, 10 Jun 2023
 08:25:50 +0000
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
Thread-Index: AQHZh1MX+qQj9H8mMkuYpu12F27VUa9dHygAgAA8LwCAANHcgIAAV3oAgB8gkYCAAIteAIABflkAgAQsq4A=
Date:   Sat, 10 Jun 2023 08:25:50 +0000
Message-ID: <580B5BEE-3D59-414C-B780-6115952AF183@oracle.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <16d9fda4-3ead-7d5e-9f54-ef29fbd932ac@redhat.com>
 <87zg64nhqh.wl-maz@kernel.org>
 <d0b77823-c04c-4ee0-cb55-2cc20a48903b@redhat.com>
 <86r0rfkpwd.wl-maz@kernel.org>
 <bdcf630c-b6a7-0649-8419-15f98f6b1a0c@redhat.com>
 <054769EB-0722-45FB-8670-23CC7915AAA9@oracle.com>
 <14268e71-686d-9c51-901b-6985ad91537f@redhat.com>
In-Reply-To: <14268e71-686d-9c51-901b-6985ad91537f@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|DS7PR10MB5182:EE_
x-ms-office365-filtering-correlation-id: 1cfe8a7b-b942-436d-7047-08db698c4cb3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SQ2vYcBRO7YzENgqgZFXWTvZZkpJqLeVcBI/FYoulNKa844ToDif5gxZQBcnadvmyekZfe92GJFlJBSko00ililcqfV6SXKaW62WP0OQHElAmeurI5DyTjx3Nd2N12YNCrdCSs1zxBDAbTt9MBD55Sqpd/lBfKwRw9nWTR3254uvA30wxXn4Y01jjFLPxWCgXC2fx2W1qXZ6cfex2ykXhH8aX8aCGKCNFiIIqAXcyTAcxOBnw5Ec84iuQ0AMSX+tHbCGNCEtqoCqOXfdeCaga178JnIvivfI4x+reuJYXu9nLxoRww6USEklqFcYoyAhs5DkrBmFoGk/DYt+c9avgkmD3zTTDuyD54s2TIY6IItsmSQPVnCIT+sWrAZsSu43KWKQXTHv9BRap+2jYvHT5pGWfPFe5YWhdP7flSXXsG03oePhpJhQjv4TT0APLmw9RhYZ/rpIhAbpVjYFwdmL83IpNzaNJPB9ZXGhdjdsY6lqXzBxTac/xRoWwXw7I/8YfbSRJ0SYhS14n+zBUTFceVxVBXnZowmHx4S+Jgbl6ODXxyoif3zhJssRX9mnoA8Bv9qI9F4eArTwB/NK4JIeW4JYf6GJinxCKzN7KZaK/UMp+CQpWo4Rj2fRh9QaxEtyq3qggsNQ70z8KA7dy4QazA0cg4ErrMN2s8gm6IKMNtET5JFFMintPvijVydZjNf9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(6486002)(966005)(36756003)(83380400001)(2616005)(38100700002)(86362001)(38070700005)(122000001)(33656002)(6506007)(6512007)(53546011)(186003)(2906002)(54906003)(4326008)(6916009)(44832011)(64756008)(316002)(7416002)(91956017)(66446008)(66476007)(66556008)(66946007)(76116006)(41300700001)(5660300002)(71200400001)(478600001)(8936002)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dU41dk5XY3ZhWHdTWUxXUURQY2dkbmhHTmpYVUlZRmc2M3JUd2NaekY2Q3ZJ?=
 =?utf-8?B?eUZ2NkR4MnNMQ2MvbFlQa3NSSm1hajBHQ1NZazArRU53dkRmSVN4RzBxN094?=
 =?utf-8?B?U1ZmZkZ1K1pyYXM2UFNjZFFoRUVmclhzSVhLa2ZyNVNlS3JoM2kzdXI2VlBU?=
 =?utf-8?B?K25PMHFRN1RqemZLUkhIVlFpV0xYbXc0d1lRUjI3ODNBOUV2ZDFRTlMvdElj?=
 =?utf-8?B?Y3pVd0kwTmFCYjByNXBvSFJXSjJlYm1KbW5nbFpNaGYxamgxYm40VEVXbm0v?=
 =?utf-8?B?RlVCUUhoWlp0RHg2cElZUUR2RkgyeU8zaVQvQ2h0K2RyQ3pJSmVoU3BoR05X?=
 =?utf-8?B?VWZaZHN2STNySzVmMkN5eUtFWTZCSmxBa0NTVUNwTXRrUlhyRmlxaHI1MGl3?=
 =?utf-8?B?UThaOFZyY2RFeVVGS1MvVEtyYnZIVTI3Vlk4dHlwcDBBOUt1UkdiK2NSc09i?=
 =?utf-8?B?aGdaZnE3YWdQNlJwaWZzMmFvTzRIUkduWmlKUFpnRVZNU3UyZEtEMzdzUEtl?=
 =?utf-8?B?SEx3NUI3RWYxeU5KNm1rZU1yR1p2Tkx2ejJJTVJoamdNdGZsbFBqSkxDVEp0?=
 =?utf-8?B?Q2VOQUVyZkpjSVJYU21PUGs0WFVkeVJ1OTVjcVdYYnlRNzFIWjVwb0xUREJV?=
 =?utf-8?B?eVlCWVltTXN5RGY3ZmNYejFiaXZRSXp6RVI0RVRUVGJFeFd5WXBMb0pabFZU?=
 =?utf-8?B?b3RHeHQrSkNDaHVaQWFvQ1V3ejJkOXZoL2xMQ1dQZHRMWFRSU1NNY3IzOHpl?=
 =?utf-8?B?aC9TSmJkR0VIUi9PRnliS1l3UENCUW1SMnJLczE5ZFBoKys1bEtnTzdEejNh?=
 =?utf-8?B?TTlZZnViRjdkUVpkVTRBYnFNQk1qMENxMmdqbldLTEV3Q2VIdHB0a042ekRl?=
 =?utf-8?B?UCtPNEgzUUxrenAyc09XMXJnVU4wOWtCZGVzSlpDbi9PTk9pV1g3YkhDbktD?=
 =?utf-8?B?L3Y3YkhVL0N0ZlVqZ1B5NlEyZHp4K1RLUWl1T3Zydmx5VE1hd0F4ZEdodlpO?=
 =?utf-8?B?OXdzeFpxSVdpVE16dmcrK3B4bWRNSThINkV5UlFVazJjdWprV3hkWFJQaEFq?=
 =?utf-8?B?dW5WTWxNUU5MQ2duS2kwaXhPUE1IQjdTOW15Nk9ZUkxoaEl4WC85NkQ0TmNF?=
 =?utf-8?B?dmU1LzZ2aTVlUW1OVnI4VDlNZUdoSThackdPeWR1L3dFNTc4Z1c2ODZ6VFh4?=
 =?utf-8?B?MU9UMWI3ejlqUWJ1c2ltcWtyYk9nbVlEYUY5U0FKT0VvUkFzMThJdjZpcG9G?=
 =?utf-8?B?Qjg2aTdJRzZrc2ExZHVCTWs5VUZVY3ZuT3RuT3lva1NNQWozMFN3NmI0YlZt?=
 =?utf-8?B?S051dmU4SG1IbGVoZFJ1OEQweVJvTE5hU1E1cHNLSDQvTGFFYi9LeGJuS2sr?=
 =?utf-8?B?QXZuUE42NGMyN2krY3I1T2UyaHg1ZGNSZXdxeGFkb1Y3ZjAxRFJuQ2szN0Vj?=
 =?utf-8?B?RFBjVk5BYkpIUVV3c1RvYnM4YlBwMFF4UHMyVUFIWlY2bG1kMjNxdCt4NTZl?=
 =?utf-8?B?M0Z4MG16R1NGcm9GV0prTjlkc25zR1RFMUIxaUtyeUYzRWsrZ2tLTW5aL1Ri?=
 =?utf-8?B?eXRIc0dtWXNYR1FoazFkeStGSUJZMzVwb3lDeGx4M3BWd2xpalM3L2pWckov?=
 =?utf-8?B?U0FqWUY1L0t1SnJvMmJjL3NucWdqQXM2S09NRE0wU2FtMHBDRW9meHMwaWdG?=
 =?utf-8?B?aXRaeEhJU3kwMmlweklLYkhsRUVjK3Q0Nno4MGVoVHZUNkFhOTJRKytZVDZo?=
 =?utf-8?B?MDFPVlJ3QUFmSUFDMVVBQy92SCtuZmhsZkJhaGsyMXo4L1orLzVPVFNVYkFa?=
 =?utf-8?B?bHJOTmEzT3hycXN6QVp3b24xNkNRTlJ1ZzhIdkM3d01oTHhMMHAyNFk4MWJn?=
 =?utf-8?B?Qjh0cCs5a1JyeGpoa3R2cmN3ZjhCRDc3UWlINk4xVzRMNThkT0h3UlV2ODBj?=
 =?utf-8?B?N1lYQmdpSGRZNGFrbThCWjIwWXlIWTdwTjFBZ2pjWkZZcmM0a3J5YzZPbGdm?=
 =?utf-8?B?VUVEU2dES0Y5cjgxS3VSYlJORFczVUNjWWE5QkptRndSclVLMWhLYWdTNk8y?=
 =?utf-8?B?a3A4VGRWOFdjdGp4R0Fpa1lCMUd5UFpscnk4RU1paUVVZlBOa3pOR2M2cXZa?=
 =?utf-8?B?Y2MycTJmVzVwZElXVnpTMGFXcXZ6Y3BWU1VoWkdTOGZlSGEvdlpDZE10cG5Q?=
 =?utf-8?Q?3/gt+9r/kIjz6IKvB1y7otU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A5878974E909A4096A3E2A19565811F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?czFkMlQwbzZHWjgwRlRFcjA5a21BNDhZS2JEMkZGaWNFd3ZicXZEQUZ3czFn?=
 =?utf-8?B?RkxUdTlaWFJmWVYyTnVuR1ZjUVhJTmJpYzVSSHFPTXdNUlhSSzYvYit0dThE?=
 =?utf-8?B?MjM1N3gyc1JtSUVReGxCSjZEcmFwRzNhSFRGSTZXOGFSdVlENXpjYzN5azB3?=
 =?utf-8?B?TmRTcFJxUjRRdkFPOXN4c2poWXlOSVE2ZFZPV2xvZ1Y3M2tYTzh1S1dpL1V0?=
 =?utf-8?B?TlB4d0hOaE1IYi9Ua202UHNIVVNlTUtWMnlUK1ViaXNMMTNuNHdBUWluWUZw?=
 =?utf-8?B?SDdFSnBvcXB2VVJBYkFScFcvUmhORUZXY0YrYUo4MTlTR2lURU9RdDRINGRD?=
 =?utf-8?B?MzZQMm1oMStVWG0vMDduU3ZWemZXeFV3MjNLRVRDUE0vYnVsaFY0Ym12OTN1?=
 =?utf-8?B?MjQxRXlBSE5iYmRSUTcvbUpNTlVYTWQ1bFNwM0V1M0RoQXR0RUcxdnY3YmUz?=
 =?utf-8?B?MitQckhhMWNRbXF5aUFFR1kxUDMrc2k5ODltTFRVbHE3aVR5VnFJTnFFNnEy?=
 =?utf-8?B?UVRlQWRCekFkeGliSnhWcEJIeS9WNE5CemdFWjM5cjMyVitrUkpyR3FYaHRP?=
 =?utf-8?B?emNCeDhlVGlWb3JVVXorN0t5ZmVwbGgyd3JpLzY3RzhXZWlRVk1CRytpbWtT?=
 =?utf-8?B?eUhvams1UkxTTnduZGpuVE5lUDlPWDNxZ0hhRmVmTW5SRnBKdGJHaE5vbzJZ?=
 =?utf-8?B?SUNWb3dqbEM5cTFTZGFjcWtyOVhpMkJJNVZjWk5RUFNzWGZVQWdKc1lWb005?=
 =?utf-8?B?UlViSldDUFRIbU8rTVM4WHBaSjVqNDJWS3NWaFQ3djE5Vy8rR0F0U2tTRmsy?=
 =?utf-8?B?OGRJM1diOHpaM1N1a1RSaWduaUFBcGJFSkoxSy94emhoczhLZlVQcGs5L3NK?=
 =?utf-8?B?SnVMbnRnZk04M05hUUdQTVdOSUE2eCtaRHFBSjhiUlpqYzlSVUlEV1pTUlFk?=
 =?utf-8?B?QzVDbTlKU0xFem5IaFVqaS9ab3E3cS8wNE5ONE04K25teVE2WUJkQ0dhcjBu?=
 =?utf-8?B?Wk9uRHRMM2FFZlhPTHZPZDZXd3VGaEFQT0FvMDBEUkY1T1VHUkdYS0c0alJB?=
 =?utf-8?B?NFJZNklqdTlrdzloQXVIaFMybEFPN2lUTjdudTVTK1EwcmNyTXJTbXovKzFG?=
 =?utf-8?B?RFVIeTNMRmM1VW5IalNxNlhhVzY3TWxBNEFBWGJJb09naSsrbVpRRkZuZ2xk?=
 =?utf-8?B?d2pZQXZaQU11c0FqZjlUYStXemwwc2xFZmIzclZiUTlSQWc5alVLSDJPS2Rl?=
 =?utf-8?B?d2hOM0dDbFJkQVNBdkt0SmljdzhUMWVUSkZwUjJOTkdMRnIrNVVMNStQVHJh?=
 =?utf-8?B?a1VNYnQ3MS9ZUWRvSmgwaHVraWJHZ2orNkJPWG95VkhLOWVKY0lDL2RVK3E3?=
 =?utf-8?B?dWMreTJ5Y1JWeGQ2ODdPVDZVVTQraVM3V2xhazhXK0Q1OHgxMnozWCtqb1Uz?=
 =?utf-8?B?T2xYZEtQbzUvRmU2anROYk9BQW5iN1B5L3pvTVdWV3pNbm5iRmFBRHI3U0VE?=
 =?utf-8?Q?yHJi6OEi5tKVfN4jBEQB/Jq9H2P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfe8a7b-b942-436d-7047-08db698c4cb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2023 08:25:50.6063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F8bqhXIPjHpulyxR4C7GHe2bZ/Sp5jWGGhvs23++LdY35tD1IcxXBjxk9JM4Kg4G0Flz8+sEqV80WXl1f27VZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-10_05,2023-06-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306100070
X-Proofpoint-GUID: v65PSZeFvpcXsOr7vylAWUr7grAsaUaq
X-Proofpoint-ORIG-GUID: v65PSZeFvpcXsOr7vylAWUr7grAsaUaq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBPbiA3IEp1biAyMDIzLCBhdCAxNjo0MCwgRXJpYyBBdWdlciA8ZWF1Z2Vy
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gSGkgTWlndWVsLA0KPiANCj4gT24gNi82LzIzIDE5
OjUyLCBNaWd1ZWwgTHVpcyB3cm90ZToNCj4+IEhlbGxvIEVyaWMsIE1hcmMsDQo+PiANCj4+PiBP
biA2IEp1biAyMDIzLCBhdCAwOTozMywgRXJpYyBBdWdlciA8ZWF1Z2VyQHJlZGhhdC5jb20+IHdy
b3RlOg0KPj4+IA0KPj4+IEhpIE1hcmMsDQo+Pj4gDQo+Pj4gT24gNS8xNy8yMyAxNjoxMiwgTWFy
YyBaeW5naWVyIHdyb3RlOg0KPj4+PiBPbiBXZWQsIDE3IE1heSAyMDIzIDA5OjU5OjQ1ICswMTAw
LA0KPj4+PiBFcmljIEF1Z2VyIDxlYXVnZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+Pj4+PiANCj4+
Pj4+IEhpIE1hcmMsDQo+Pj4+PiBIaSBNYXJjLA0KPj4+Pj4gT24gNS8xNi8yMyAyMjoyOCwgTWFy
YyBaeW5naWVyIHdyb3RlOg0KPj4+Pj4+IE9uIFR1ZSwgMTYgTWF5IDIwMjMgMTc6NTM6MTQgKzAx
MDAsDQo+Pj4+Pj4gRXJpYyBBdWdlciA8ZWF1Z2VyQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+Pj4+
PiANCj4+Pj4+Pj4gSGkgTWFyYywNCj4+Pj4+Pj4gDQo+Pj4+Pj4+IE9uIDUvMTUvMjMgMTk6MzAs
IE1hcmMgWnluZ2llciB3cm90ZToNCj4+Pj4+Pj4+IFRoaXMgaXMgdGhlIDR0aCBkcm9wIG9mIE5W
IHN1cHBvcnQgb24gYXJtNjQgZm9yIHRoaXMgeWVhci4NCj4+Pj4+Pj4+IA0KPj4+Pj4+Pj4gRm9y
IHRoZSBwcmV2aW91cyBlcGlzb2Rlcywgc2VlIFsxXS4NCj4+Pj4+Pj4+IA0KPj4+Pj4+Pj4gV2hh
dCdzIGNoYW5nZWQ6DQo+Pj4+Pj4+PiANCj4+Pj4+Pj4+IC0gTmV3IGZyYW1ld29yayB0byB0cmFj
ayBzeXN0ZW0gcmVnaXN0ZXIgdHJhcHMgdGhhdCBhcmUgcmVpbmplY3RlZCBpbg0KPj4+Pj4+Pj4g
Z3Vlc3QgRUwyLiBJdCBpcyBleHBlY3RlZCB0byByZXBsYWNlIHRoZSBkaXNjcmV0ZSBoYW5kbGlu
ZyB3ZSBoYXZlDQo+Pj4+Pj4+PiBlbmpveWVkIHNvIGZhciwgd2hpY2ggZGlkbid0IHNjYWxlIGF0
IGFsbC4gVGhpcyBoYXMgYWxyZWFkeSBmaXhlZCBhDQo+Pj4+Pj4+PiBudW1iZXIgb2YgYnVncyB0
aGF0IHdlcmUgaGlkZGVuIChhIGJ1bmNoIG9mIHRyYXBzIHdlcmUgbmV2ZXINCj4+Pj4+Pj4+IGZv
cndhcmRlZC4uLikuIFN0aWxsIGEgd29yayBpbiBwcm9ncmVzcywgYnV0IHRoaXMgaXMgZ29pbmcg
aW4gdGhlDQo+Pj4+Pj4+PiByaWdodCBkaXJlY3Rpb24uDQo+Pj4+Pj4+PiANCj4+Pj4+Pj4+IC0g
QWxsb3cgdGhlIEwxIGh5cGVydmlzb3IgdG8gaGF2ZSBhIFMyIHRoYXQgaGFzIGFuIGlucHV0IGxh
cmdlciB0aGFuDQo+Pj4+Pj4+PiB0aGUgTDAgSVBBIHNwYWNlLiBUaGlzIGZpeGVzIGEgbnVtYmVy
IG9mIHN1YnRsZSBpc3N1ZXMsIGRlcGVuZGluZyBvbg0KPj4+Pj4+Pj4gaG93IHRoZSBpbml0aWFs
IGd1ZXN0IHdhcyBjcmVhdGVkLg0KPj4+Pj4+Pj4gDQo+Pj4+Pj4+PiAtIENvbnNlcXVlbnRseSwg
dGhlIHBhdGNoIHNlcmllcyBoYXMgZ29uZSBsb25nZXIgYWdhaW4uIEJvby4gQnV0DQo+Pj4+Pj4+
PiBob3BlZnVsbHkgc29tZSBvZiBpdCBpcyBlYXNpZXIgdG8gcmV2aWV3Li4uDQo+Pj4+Pj4+PiAN
Cj4+Pj4+Pj4+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjMwNDA1MTU0MDA4LjM1
NTI4NTQtMS1tYXpAa2VybmVsLm9yZw0KPj4+Pj4+PiANCj4+Pj4+Pj4gSSBoYXZlIHN0YXJ0ZWQg
dGVzdGluZyB0aGlzIGFuZCB3aGVuIGJvb3RpbmcgbXkgZmVkb3JhIGd1ZXN0IEkgZ2V0DQo+Pj4+
Pj4+IA0KPj4+Pj4+PiBbICAxNTEuNzk2NTQ0XSBrdm0gWzc2MTddOiBVbnN1cHBvcnRlZCBndWVz
dCBzeXNfcmVnIGFjY2VzcyBhdDoNCj4+Pj4+Pj4gMjNmNDI1ZmQwIFs4MDAwMDIwOV0NCj4+Pj4+
Pj4gWyAgMTUxLjc5NjU0NF0gIHsgT3AwKCAzKSwgT3AxKCAzKSwgQ1JuKDE0KSwgQ1JtKCAzKSwg
T3AyKCAxKSwgZnVuY193cml0ZSB9LA0KPj4+Pj4+PiANCj4+Pj4+Pj4gYXMgc29vbiBhcyB0aGUg
aG9zdCBoYXMga3ZtLWFybS5tb2RlPW5lc3RlZA0KPj4+Pj4+PiANCj4+Pj4+Pj4gVGhpcyBzZWVt
cyB0byBiZSB0cmlnZ2VyZWQgdmVyeSBlYXJseSBieSBFREsyDQo+Pj4+Pj4+IChBcm1Qa2cvRHJp
dmVycy9UaW1lckR4ZS9UaW1lckR4ZS5jKS4NCj4+Pj4+Pj4gDQo+Pj4+Pj4+IElmIEkgYW0gbm90
IHdyb25nIHRoaXMgQ05UVl9DVExfRUwwLiBEbyB5b3UgaGF2ZSBhbnkgaWRlYT8NCj4+Pj4+PiAN
Cj4+Pj4+PiBTbyBoZXJlJ3MgbXkgY3VycmVudCBhbmFseXNpczoNCj4+Pj4+PiANCj4+Pj4+PiBJ
IGFzc3VtZSB5b3UgYXJlIHJ1bm5pbmcgRURLMiBhcyB0aGUgTDEgZ3Vlc3QgaW4gYSBuZXN0ZWQN
Cj4+Pj4+PiBjb25maWd1cmF0aW9uLiBJIGFsc28gYXNzdW1lIHRoYXQgeW91IGFyZSBub3QgcnVu
bmluZyBvbiBhbiBBcHBsZQ0KPj4+Pj4+IENQVS4gSWYgdGhlc2UgYXNzdW1wdGlvbnMgYXJlIGNv
cnJlY3QsIHRoZW4gRURLMiBydW5zIGF0IHZFTDIsIGFuZCBpcw0KPj4+Pj4+IGluIG5WSEUgbW9k
ZS4NCj4+Pj4+PiANCj4+Pj4+PiBGaW5hbGx5LCBJJ20gZ29pbmcgdG8gYXNzdW1lIHRoYXQgeW91
ciBpbXBsZW1lbnRhdGlvbiBoYXMgRkVBVF9FQ1YgYW5kDQo+Pj4+Pj4gRkVBVF9OVjIsIGJlY2F1
c2UgSSBjYW4ndCBzZWUgaG93IGl0IGNvdWxkIGZhaWwgb3RoZXJ3aXNlLg0KPj4+Pj4gYWxsIHRo
ZSBhYm92ZSBpcyBjb3JyZWN0Lg0KPj4+Pj4+IA0KPj4+Pj4+IEluIHRoZXNlIHByZWNpc2UgY29u
ZGl0aW9ucywgS1ZNIHNldHMgdGhlIENOVEhDVExfRUwyLkVMMVRWVCBiaXQgc28NCj4+Pj4+PiB0
aGF0IHdlIGNhbiB0cmFwIHRoZSBFTDAgdmlydHVhbCB0aW1lciBhbmQgZmFpdGhmdWxseSBlbXVs
YXRlIGl0IChpdA0KPj4+Pj4+IGlzIG90aGVyd2lzZSB3cml0dGVuIHRvIG1lbW9yeSwgd2hpY2gg
aXNuJ3QgdmVyeSBoZWxwZnVsKS4NCj4+Pj4+IA0KPj4+Pj4gaW5kZWVkDQo+Pj4+Pj4gDQo+Pj4+
Pj4gQXMgaXQgdHVybnMgb3V0LCB3ZSBkb24ndCBoYW5kbGUgdGhlc2UgdHJhcHMuIEkgZGlkbid0
IHNwb3QgaXQgYmVjYXVzZQ0KPj4+Pj4+IG15IHRlc3QgbWFjaGluZXMgYXJlIGFsbCBBcHBsZSBi
b3hlcyB0aGF0IGRvbid0IGhhdmUgYSBuVkhFIG1vZGUsIHNvDQo+Pj4+Pj4gbm90aGluZyBvbiB0
aGUgblZIRSBwYXRoIGlzIGdldHRpbmcgKkFOWSogY292ZXJhZ2UuIEhpbnQ6IGhhdmluZw0KPj4+
Pj4+IGFjY2VzcyB0byBzdWNoIGEgbWFjaGluZSB3b3VsZCBoZWxwIChzaGlwcGluZyBhZGRyZXNz
IG9uIHJlcXVlc3QhKS4NCj4+Pj4+PiBPdGhlcndpc2UsIEknbGwgZXZlbnR1YWxseSBraWxsIHRo
ZSBuVkhFIHN1cHBvcnQgYWx0b2dldGhlci4NCj4+Pj4+PiANCj4+Pj4+PiBJIGhhdmUgd3JpdHRl
biB0aGUgZm9sbG93aW5nIHBhdGNoLCB3aGljaCBjb21waWxlcywgYnV0IHRoYXQgSSBjYW5ub3QN
Cj4+Pj4+PiB0ZXN0IHdpdGggbXkgY3VycmVudCBzZXR1cC4gQ291bGQgeW91IHBsZWFzZSBnaXZl
IGl0IGEgZ28/DQo+Pj4+PiANCj4+Pj4+IHdpdGggdGhlIHBhdGNoIGJlbG93LCBteSBndWVzdCBi
b290cyBuaWNlbHkuIFlvdSBkaWQgaXQgZ3JlYXQgb24gdGhlIDFzdA0KPj4+Pj4gc2hvdCEhISBT
byB0aGlzIGZpeGVzIG15IGlzc3VlLiBJIHdpbGwgY29udGludWUgdGVzdGluZyB0aGUgdjEwLg0K
Pj4+PiANCj4+Pj4gVGhhbmtzIGEgbG90IGZvciByZXBvcnRpbmcgdGhlIGlzc3VlIGFuZCB0ZXN0
aW5nIG15IGhhY2tzLiBJJ2xsDQo+Pj4+IGV2ZW50dWFsbHkgZm9sZCBpdCBpbnRvIHRoZSByZXN0
IG9mIHRoZSBzZXJpZXMuDQo+Pj4+IA0KPj4+PiBCeSB0aGUgd2F5LCB3aGF0IGFyZSB5b3UgdXNp
bmcgYXMgeW91ciBWTU0/IEknZCByZWFsbHkgbGlrZSB0bw0KPj4+PiByZXByb2R1Y2UgeW91ciBz
ZXR1cC4NCj4+PiBTb3JyeSBJIG1pc3NlZCB5b3VyIHJlcGx5LiBJIGFtIHVzaW5nIGxpYnZpcnQg
KyBxZW11IChmZWF0IE1pZ3VlbCdzIFJGQykNCj4+PiBhbmQgZmVkb3JhIEwxIGd1ZXN0Lg0KPj4+
IA0KPj4gDQo+PiBGb2xsb3dpbmcgdGhpcyBzdWJqZWN0LCBJ4oCZdmUgZm9yd2FyZCBwb3J0ZWQg
QWxleGFuZHJ14oCZcyBLVVQgcGF0Y2hlcw0KPj4gKCBhbmQgSSBlbmNvdXJhZ2Ugb3RoZXJzIHRv
IGRvIGl0IGFsc28gPSkgKSB3aGljaCBleHBvc2UgYW4gRUwyIHRlc3QgdGhhdA0KPiANCj4gRG8g
eW91IGhhdmUgYSBicmFuY2ggYXZhaWxhYmxlIHdpdGggQWxleGFuZHJ1J3MgcmViYXNlZCBrdXQg
c2VyaWVzPw0KDQpOb3cgSSBkbyA6KQ0KDQpodHRwczovL2dpdGh1Yi5jb20vbWx1aXMva3ZtLXVu
aXQtdGVzdHMvdHJlZS9udi1XSVANCg0KVGhhbmtzLA0KTWlndWVsDQoNCj4gDQo+IFRoYW5rcw0K
PiANCj4gRXJpYw0KPj4gZG9lcyB0aHJlZSBjaGVja3M6DQo+PiANCj4+IC0gd2hldGhlciBWSEUg
aXMgc3VwcG9ydGVkIGFuZCBlbmFibGVkDQo+PiAtIGRpc2FibGUgVkhFDQo+PiAtIHJlLWVuYWJs
ZSBWSEUgIA0KPj4gDQo+PiBJ4oCZbSBydW5uaW5nIHFlbXUgd2l0aCB2aXJ0dWFsaXphdGlvbj1v
biBhcyB3ZWxsIHRvIHJ1biB0aGlzIHRlc3QgYW5kIGl0IGlzIHBhc3NpbmcgYWx0aG91Z2gNCj4+
IHByb2JsZW1zIHNlZW0gdG8gaGFwcGVuIHdoZW4gcnVubmluZyB3aXRoIHZpcnR1YWxpemF0aW9u
PW9mZiwgd2hpY2ggSeKAmW0gc3RpbGwgbG9va2luZyBpbnRvIGl0Lg0KPj4gDQo+PiBUaGFua3MN
Cj4+IE1pZ3VlbA0KPj4gDQo+Pj4gVGhhbmtzIHRvIHlvdXIgZml4LCB0aGlzIGJvb3RzIGZpbmUu
IEJ1dCBhdCB0aGUgbW9tZW50IGl0IGRvZXMgbm90DQo+Pj4gcmVib290IGFuZCBoYW5ncyBpbiBl
ZGsyIEkgdGhpbmsuIFVuZm9ydHVuYXRlbHkgdGhpcyB0aW1lIEkgaGF2ZSBubw0KPj4+IHRyYWNl
IG9uIGhvc3QgOi0oIFdoaWxlIGxvb2tpbmcgYXQgeW91ciBzZXJpZXMgSSB3aWxsIGFkZCBzb21l
IHRyYWNlcy4NCj4+PiANCj4+PiBFcmljDQo+Pj4+IA0KPj4+PiBDaGVlcnMsDQo+Pj4+IA0KPj4+
PiBNLg0KDQoNCg==
