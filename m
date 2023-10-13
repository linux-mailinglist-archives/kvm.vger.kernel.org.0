Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327F87C8BE2
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 19:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjJMRA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 13:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjJMRA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 13:00:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7640CAD
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 10:00:24 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DGaTvC015275;
        Fri, 13 Oct 2023 16:58:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3C8CKTro8cM0p77+Mq+LlU9AtcFrXzHXTss7RX2SWGE=;
 b=DoXAsmc2RvVVA2JrECoyzizKXztv4+4XBEI0v+o9IZJKF+6WEalvXJUtUzDqpmEfP2Yr
 sAHo2nZVk1rFr2h0NkgTuEKCw2c9cgmoomaZQSxkJGtErwgtJYxBDKLQ08IoDpkUNy27
 OCPO/LQjQkxnz4Sn5Z1GSm34GafBBewWAg/NqDrmTVbpzQt/FNJmjNk12ri2u63uxCG4
 hkFbhhA/UnY/8wMr4zBt08e/CFsObcteovDsUZv+UmP5K446vqO9/1PdiskEXzXElLMh
 fgs7FaWJZVdT0vnixkv+sV4bzzu9N1/rGhghGOoZIQi1fnpOq4sFDAEozEcq3dSOP0x0 bQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tmh8a2rf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:58:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DGoeeY036790;
        Fri, 13 Oct 2023 16:58:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tpt0umt9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:58:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnGoGQ+AH9PXqcVDna3wX/Gx9+KfUaxKIRw2SDhD0Si2CVKDKhiIAJtAQvfgVd6p8NS/xHj/7wPUup2DGZfrc59CEaYhccscuvrKWANEdzYd1vsQU/23YD4PtUr6mLHg+mdQeLxQRmsBfCt/tuGf14bA5r0trFTHYuXC1SW+TODoYkbk0WmnPxdHX/UxPuCDWHm13etOKfTGDx/3u7ZM6S2bNzRZAkBnT3tGkPhWMp05U503J3aEcnfmsGrE0l8wx8v0MATFPnefdVy3T0gHj+8sJ7OCwz9ujcBUAxFot4bsBVwkyTe9WjJp0Y9gdwJ/6pRrEV7QKItI3nt0QRUzDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3C8CKTro8cM0p77+Mq+LlU9AtcFrXzHXTss7RX2SWGE=;
 b=QzK+0VjZl1Lss8pVYQEk9BC9/hKAu7sIps/hZoS0geziejwkWPx32IgMpLsCuuocKPt9kezf9vwx8uHM4C2fEhL396Svms6Xk8Jvm7ZGN/pnimg/hMt8PH2Tqvuyfw8Rb1BGHN3uBmfwS4dkClfNG9J+kq8zt+hRPL1dxVS4PMnkqbp3urypylYnskZjd6/6vtbYgbWHDJmNah76k0VVfJt3ivcD7EAQHu0KLvQqbIPHMtFVvIHP1pkSwYo0DIQpdWUWqZEopUhXdwyYTEged9Kimtf4btEh0OAKmhYg2mFWifb6d8MyXxt+xbJimBrf6t8FimaW7BdgTDYjUaIjDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3C8CKTro8cM0p77+Mq+LlU9AtcFrXzHXTss7RX2SWGE=;
 b=z3mbWsfq8fAqnEgVPOfjLUn1B6kEm/smiVYm3m41bdE6mg0sXmH1dGMS0AfDgzFGlQ3+29x5vMz7/8v8AhcSFkzNnJj1Zzq9ISxO5x5LYcePwCCdrZqwTIHN05FEtmYA8YxYsGFSx6Hi29aGKpM4Co2t5YetNfahGUqWU3MJQeE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 16:58:50 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 16:58:50 +0000
Message-ID: <f4b5bc41-4a56-4e41-b3a4-1f7c77989d78@oracle.com>
Date:   Fri, 13 Oct 2023 17:58:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/19] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-11-joao.m.martins@oracle.com>
 <20231013162217.GF3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013162217.GF3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0064.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: 108a9af1-957a-48d7-8bc8-08dbcc0dac29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6UvbY22vqXPxdKKxBtTjbaZXD9dNqfIuCqYfoqS+RVH9H4N8e2GHcLP1pKYoidg068ud6MpzeI47pDOlwOK0/kMQB6uomrvHF6bzEiUBrr8GgJwjmi0J+9zMStaRITWqgHVWw+ENjJ+fW8UOPglJgGxILZMjmO5DiYijuxXIWK0T5AA+CvW5WDRQ+lbPnmZptIDdD+zN8a+DB7kVICIMGaW1Ptca93i91Lq4AEOmox66Xcph/zCBoYC79IcUvNRDwNWHm03mNU4ERxb1EFp56KtKGv8GW6vxwLZqTeL2lQgAaK7h8LYlV0jqA79WxT7xY6bOdPryOXTSMaMX7Eilg/QZ2d/3jNFOks56Z77WA7wVWomEHILJj8s4UWJ87ju5AolK9ZrNGLOHj52gZ9aTa5Gjcr7Ykj4wCNxzKaXIZSv7SdnOnbrl+Aai8uQ6yeMiVcjEyvMhgDri8J0/tW9yOf9KgWQmQ3Hdfd0a9Tmc117xQk7nZ2l9BX8bjtrn3LIKJ/YQforWcsTc/A1xl7BGbX2khOK4K8elPsPemZFIN6IKjGrBOI9xDe9JTKlmsKbYQO4ZvFjd5s5AAzMalmBEnK8qAdAgo+F8EUB/e+9BHvH7/U39H/NDzfRN8LmyK1wMQed+dYCHTU3eKRORmVoAMc+J1bmHfQtm/EZlmODH9zs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(26005)(6506007)(6916009)(66556008)(316002)(36756003)(66476007)(54906003)(66946007)(53546011)(2616005)(38100700002)(86362001)(31686004)(6512007)(6486002)(478600001)(31696002)(6666004)(2906002)(7416002)(8936002)(5660300002)(4326008)(8676002)(41300700001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?citRdG5mR0c3eEUwNng5bXI2YzQwM2NKMFZ6YVlZaDNZWHQ0R2t0dlA1c203?=
 =?utf-8?B?azdoVUhyT3FHaEl0eEkwcUdvUGp4WnhYK0Vzb0xiUS9mbHhkcXRQT2tvYWtW?=
 =?utf-8?B?eU9peXNjQitrWWVmQU04Mmp1Y0tTQlFVQm9laGcycEtyUFd5RVJxZGNMU0J6?=
 =?utf-8?B?bGJHeGhpLzhIMk0xZHFOZTROQllpNXFwVlBzNHIvaVZoclB5ZlJOWWJlMFV2?=
 =?utf-8?B?SHBVZ0dKUlhhRHZqLy84bU9uUFFteGpDdVZsQklhTnU5WUhFWlFva0dhWmxW?=
 =?utf-8?B?TGJPQ1JjL1pobkFPVGFoS1g3L2NOSEtHRTgrWFFxVFZhV1Z5aFNmMHZ3cjgw?=
 =?utf-8?B?aEZucTliRS92d0N3YTVZeGxxMitSUTNoWjNUWitvSGQ1R0VXTUtaOWxQRXlG?=
 =?utf-8?B?MEJWbTZrUGFFU2tZbVJCTjQ1YWhzbVlxNVhoK0YyYktzb2hQY3hhS2Z4WDJh?=
 =?utf-8?B?cytKcHQzc1N1QUZtL2hyV1B0QlJyNVZ0V0V5aHk0SW4wMzJiSnA2MWRYSGg0?=
 =?utf-8?B?R1dibGdkVkZYTUlkNjFNMEtROTZyV0E3VCtEVzJhcWd1TmtWYysyOGlGK0Ru?=
 =?utf-8?B?bWFwUnhUTnY1WlpjYmlBTFYrT1J4N2R3bXpqQU12Mit2bUxrUnlOTTNobFpS?=
 =?utf-8?B?cEN5QWdkOEh1MS93VHpwNzA4Z3FQTDA4ZzJWakpland4ZXd6dzdPbjQvNW9w?=
 =?utf-8?B?OUlZRytudEZ4UEdXMjhDYzR0b0RySU5oRGxTbDduR01XZDZtVTdXN2UxajRP?=
 =?utf-8?B?aGFsM2dNdy9kWWlCbndNWjFDUTd4amVkemVxNkUzMDhzcVg5eElDSVRBUWQ0?=
 =?utf-8?B?VTJ5eEdOMlFjWGZhQ0ZDZ2xZN2FWWS9VaGNONEpldFRYUWJ5WWpEWWw4MVFG?=
 =?utf-8?B?WU5Ta1NNSmFsV0Z3SzBZMTJjVEtxMitBT3ZaMGl0MEF3QmZGblVua3QyOGE4?=
 =?utf-8?B?YzdPakZkYzBVTFdvT3FkdVpPeG5RMkpRZjltSlJnQnEzWmRJK2NBcWluME9q?=
 =?utf-8?B?dHVDSHZPZ29SMDA1VkQ4MU9TazdSQVpRNkF2RGJQUUtFdm93RWJzWE1SUWV5?=
 =?utf-8?B?S05tclNoYTM5M2g2MXZnTjduOEpQdStwK2haT2dvTTB2bHhva09vajVUeXRH?=
 =?utf-8?B?SnQ4WmVzUTdNR1VNcmk2TGh3cCtONU9WdnR3dklxQTdSdEtEaTEvNG1DRGtY?=
 =?utf-8?B?NWM1Z1FjNW9UZ1BGNHRJNWtjUFJiYTZrcDN4emVmYXpEYVh0N3dTczNIYWwr?=
 =?utf-8?B?b082SVV3YW5xRDNLUjdkOXM4dnFybTNUSnh5Wnp4UjlxV2lkNkkxaVFCWXRE?=
 =?utf-8?B?dm5OMjlHTElSOUxGOW1sa2x3QmVtZnQxdG5CQWF5SzhaQnF2Y3g5YVl4QWQ4?=
 =?utf-8?B?VEUzeitOeERxOGIyRlJyQmIwWm56NGR3ZHRaK1JmRXlTU0R4WFhOU1R3WnJZ?=
 =?utf-8?B?Lys3ak5BTUhhY2hxVE94WGNRQ0FTUTJpYUtRUmlaTnpvY0QrTzNaNkh2WHJs?=
 =?utf-8?B?U1VOZVczOGJ5TFZYWG54MGY2TnljcFpVV1h1Q29lWXFML3BmVmZhc2FuQmZ4?=
 =?utf-8?B?dFliQW84akNQdzQrOTNNYytXc2pmUzFXLzdUSWFnMy9BazhyUzVnSWxxQkxa?=
 =?utf-8?B?aU5uNlZod09KeEFpUlJvSUFlWTljaTU4UUhEK3F2NUNVTDFRZTRvS3dWQUJm?=
 =?utf-8?B?MG5mYWhXUC9oOW9EL0RxNnNld0RVV1JhSk5DbzBNbUg5cDRUQ0s3NVMvZnIx?=
 =?utf-8?B?WFZydXZQVzh2elJ1RFNxMlU5S0ZlVysweVJPOVZWVjc5YzhablBCRW5PY29n?=
 =?utf-8?B?bmdkU0Z1ZFF4aDRaYjE0cFhaWkNFL2czSEx2VzFzSkp2UWlaNjZBbU1qb2NU?=
 =?utf-8?B?aS9Fbk1iRUoxRDMxNjNsSlIxaHdObFFLcjEvVDZHZXd6R0pjajFYejQxWW1k?=
 =?utf-8?B?NFJUMGF1MVBWYzRMeVZMOHN2QjVaeXJaRWZ4MG1oMVBhR2VxSUp4Uy9rV0du?=
 =?utf-8?B?cXF5eFJGS2RLbFpXTExQRVNxcnl1N3luSis4bWU0bDJMYUpnUDhQMSs5dWE3?=
 =?utf-8?B?YmlLZENMc25VekNEUUgzTlE2ZWhBTFFqZlRvN0E1cytQOGpGZFFwaDFLV1Bz?=
 =?utf-8?B?QXJQR0pyc2hUT0YxQ3BSd21SYlRuVkhzTjA0bDg5NVR6Sm8yRFNkTTRLbGYr?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?b3VSU0RjYUVPSzNTQU54SXRucWUweE9NeFVLbXZ5UG13TzZHaHlUS3NaMXdl?=
 =?utf-8?B?L2xPekk3N29DRXB1Q2drTk84K0gxdDFMNExUR2VhTmFKOS9xdWZCTlRzVVhx?=
 =?utf-8?B?YW0wYjgxQW84WHQ2dEdNenFHaWs2NkdabWJ1cnJUUWVraXdIcEI3QzdFRld4?=
 =?utf-8?B?NVJxVzVySEhoa2QvbU9vb2JUUkIyQ1F4dnNQMnJodVhvOWVHQ05RMnQzbGlD?=
 =?utf-8?B?ZzBBdEJYM1BvcUpEd2M0UmNyWE93L0JQem9vaEZ3YUE3NDMyNWhqejgyVDI3?=
 =?utf-8?B?aSs5dW5xb2tXK3JZbHJCdWszQXZ5WG9wcHNvQlc4a3BDY1JScitFaVRNVDZP?=
 =?utf-8?B?L2M4THVOcUYyU2JMeS9WbUVvUlRENEpwYm11SlhIck1XUHA2UllmVDlXWEpM?=
 =?utf-8?B?NTFmVndEVVd5OXhrK1RETDZVaVdoaGpBU1hmSUprWlgxNkpCNWNZOW92VzdI?=
 =?utf-8?B?OHVGUC95d0tpNWZRanBFMGlJYlErRkZhWjBIaWh1K1Y0NytjblpBZGRDZ0RS?=
 =?utf-8?B?Qm4rUUE1S01PN3FJaTl5MDU2ckVyY1Y4dG9QMTA5eWxEb2RBKzNsTEUzWW1u?=
 =?utf-8?B?c2RWa0FzWkl2cy9qenIwZ05lL0dVYVVlS1kzZ05XV1JyTS9yZG1OanFuclBF?=
 =?utf-8?B?Z0tmTFhQTmNEdWJnMUZPVURWTytYSEt3YlBKckJkcExIdW9HOXJEN2hBMjYw?=
 =?utf-8?B?SlV1ditxWjNTanM0Z2Zkb0FmZmQ5VTlXZTJEa2tYVm5YMmFPTlp2bVd5WnhB?=
 =?utf-8?B?S2E5NFBMeG9rcVg2cGhCVU0rOS94TktJMG5SeUNHSlFINUdkZmNROEZEMWgw?=
 =?utf-8?B?TElrakNSWXA5eWNYR0UycjNiY1NyMjRpY0E5eGt6Q0p3aEtBbjZpNFA5blYv?=
 =?utf-8?B?NzE2cWc1Q2d3VnhsMGFSNld5WG5STk8rNi9wZWw0VldCN3krajFLYzhENE1n?=
 =?utf-8?B?WnNpMVB4RXJUSzRrYkNPaGtsMDhER1Znc05GSUluNWx2ZEpPOHlxb2hPdURX?=
 =?utf-8?B?cjRsaEVXZ3Jab25uamVkNTEweWNuUjNRODRoWVppNm9iVEhXZGNQeEZhTXdH?=
 =?utf-8?B?UDUwU0hWNVdVbGRwaVQySnJMY0d5djFsb3ByUWUrWm42Q1QxUGxPVlNReVk3?=
 =?utf-8?B?bzBKbWpYcmR3QXUwTUxVUDQ4dVFxWjA0RVlUQWdQOXVzbmlDL2tsU3IvcjNx?=
 =?utf-8?B?SUkrZlFZb2RmZWJmdUlVejRwdDB6ODlJUHhWSk9yd3NESUdUNlBPUWFnM0dn?=
 =?utf-8?B?d3Axc3JnOHpXNERGVjVGQS9sa09MZURBYnBRV3JWZVdEb1FhY1h1T0J4T2hZ?=
 =?utf-8?B?MWxUMVJkMVExYzdoUnBQa3N1QjdJN0czVFQydC9nVjdHK3pjK1NtdHlZZURI?=
 =?utf-8?B?bFEzWmVQeDVHUGF6L3l4RUNaM1B2bHU5N0N2QUxrSGNpSmc4YjJHOTFlSTFY?=
 =?utf-8?Q?eo67RFZs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108a9af1-957a-48d7-8bc8-08dbcc0dac29
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:58:50.0477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TE2Y8O3cytGw5595OPhDWIJc85UkM8uHgHr6fAMuM+OZGBpLSkdnDvDW21BKE4Njq+S/T7wmPjcQsabcurWRgcVZYtRsmh1z+P0S0mlJ/DQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_08,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130145
X-Proofpoint-GUID: hX3iakoxz8qWfDoHBhfq0T1HxcsVecnL
X-Proofpoint-ORIG-GUID: hX3iakoxz8qWfDoHBhfq0T1HxcsVecnL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13/10/2023 17:22, Jason Gunthorpe wrote:
> On Sat, Sep 23, 2023 at 02:25:02AM +0100, Joao Martins wrote:
> 
>> +int iommufd_check_iova_range(struct iommufd_ioas *ioas,
>> +			     struct iommufd_dirty_data *bitmap)
>> +{
>> +	unsigned long pgshift, npages;
>> +	size_t iommu_pgsize;
>> +	int rc = -EINVAL;
>> +
>> +	pgshift = __ffs(bitmap->page_size);
>> +	npages = bitmap->length >> pgshift;
>> +
>> +	if (!npages || (npages > ULONG_MAX))
>> +		return rc;
>> +
>> +	iommu_pgsize = 1 << __ffs(ioas->iopt.iova_alignment);
> 
> iova_alignment is not a bitmask, it is the alignment itself, so is
> redundant.
> 
Yes, let me remove it

>> +	/* allow only smallest supported pgsize */
>> +	if (bitmap->page_size != iommu_pgsize)
>> +		return rc;
> 
> != is smallest?
> 
> Why are we restricting this anyhow? I thought the iova bitmap stuff
> did all the adaptation automatically?
> 
yes, it does

> I can sort of see restricting the start/stop iova
>

There's no fundamental reason to restricting it; I am probably just too obsessed
with making the most granular tracking, but I shouldn't restrict the user to
track at some other page granularity

> 
>> +	if (bitmap->iova & (iommu_pgsize - 1))
>> +		return rc;
>> +
>> +	if (!bitmap->length || bitmap->length & (iommu_pgsize - 1))
>> +		return rc;
>> +
>> +	return 0;
>> +}
> 
>> --- a/drivers/iommu/iommufd/main.c
>> +++ b/drivers/iommu/iommufd/main.c
>> @@ -316,6 +316,7 @@ union ucmd_buffer {
>>  	struct iommu_option option;
>>  	struct iommu_vfio_ioas vfio_ioas;
>>  	struct iommu_hwpt_set_dirty set_dirty;
>> +	struct iommu_hwpt_get_dirty_iova get_dirty_iova;
>>  #ifdef CONFIG_IOMMUFD_TEST
>>  	struct iommu_test_cmd test;
>>  #endif
>> @@ -361,6 +362,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
>>  		 __reserved),
>>  	IOCTL_OP(IOMMU_HWPT_SET_DIRTY, iommufd_hwpt_set_dirty,
>>  		 struct iommu_hwpt_set_dirty, __reserved),
>> +	IOCTL_OP(IOMMU_HWPT_GET_DIRTY_IOVA, iommufd_hwpt_get_dirty_iova,
>> +		 struct iommu_hwpt_get_dirty_iova, bitmap.data),
> 
> Also keep sorted
> 
OK

>>  #ifdef CONFIG_IOMMUFD_TEST
>>  	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
>>  #endif
>> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
>> index 37079e72d243..b35b7d0c4be0 100644
>> --- a/include/uapi/linux/iommufd.h
>> +++ b/include/uapi/linux/iommufd.h
>> @@ -48,6 +48,7 @@ enum {
>>  	IOMMUFD_CMD_HWPT_ALLOC,
>>  	IOMMUFD_CMD_GET_HW_INFO,
>>  	IOMMUFD_CMD_HWPT_SET_DIRTY,
>> +	IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA,
>>  };
>>  
>>  /**
>> @@ -481,4 +482,39 @@ struct iommu_hwpt_set_dirty {
>>  	__u32 __reserved;
>>  };
>>  #define IOMMU_HWPT_SET_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_SET_DIRTY)
>> +
>> +/**
>> + * struct iommufd_dirty_bitmap - Dirty IOVA tracking bitmap
>> + * @iova: base IOVA of the bitmap
>> + * @length: IOVA size
>> + * @page_size: page size granularity of each bit in the bitmap
>> + * @data: bitmap where to set the dirty bits. The bitmap bits each
>> + * represent a page_size which you deviate from an arbitrary iova.
>> + * Checking a given IOVA is dirty:
>> + *
>> + *  data[(iova / page_size) / 64] & (1ULL << (iova % 64))
>> + */
>> +struct iommufd_dirty_data {
>> +	__aligned_u64 iova;
>> +	__aligned_u64 length;
>> +	__aligned_u64 page_size;
>> +	__aligned_u64 *data;
>> +};
> 
> Is there a reason to add this struct? Does something else use it?
> 
I was just reducing how much data I really need to pass around so consolidated
all that into a struct representing the bitmap data considering (...)

>> +/**
>> + * struct iommu_hwpt_get_dirty_iova - ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
>> + * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
>> + * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
>> + * @flags: Flags to control dirty tracking status.
>> + * @bitmap: Bitmap of the range of IOVA to read out
>> + */
>> +struct iommu_hwpt_get_dirty_iova {
>> +	__u32 size;
>> +	__u32 hwpt_id;
>> +	__u32 flags;
>> +	__u32 __reserved;
>> +	struct iommufd_dirty_data bitmap;
> 
> vs inlining here?
> 
> I see you are passing it around the internal API, but that could
> easily pass the whole command too

I use it for the read_and_clear_dirty_data (and it's input validation). Kinda
weird to do:

	iommu_read_and_clear(domain, flags, cmd)

Considering none of those functions pass command data around. If you prefer with
passing the whole command then I can go at it;
