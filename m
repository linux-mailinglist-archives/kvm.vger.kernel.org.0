Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343B9631A65
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 08:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiKUHja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 02:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiKUHj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 02:39:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75B02D1E4
        for <kvm@vger.kernel.org>; Sun, 20 Nov 2022 23:39:25 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AL7Nh31009759;
        Mon, 21 Nov 2022 07:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=GyugDkBO2NGbcJBC1K8ONyZ8gOPv53rJSYEZML/bxwA=;
 b=Skf0PcgIVtswN8gp+Ss60F229AQSHX4RgJzmfodZD9t6ScfROi+EtV5ByUSwrkYpaa/U
 HMX9jfA2monlfkBDPnLCzynWe1ubzp2Hddl6mimULIvq1C+WrvnD07xBUc9P4CRQOW0a
 TnQW/yT9Erojnsu30Sq5YM9yh7LFQ3UBcBL/D0ryPXNHe+oOoYGfTr6FR3tAcw4yXWkj
 3HMhZUOxAZAZ8KXVckR2KsQffH95ihdkGHZuo4ruJqp2YS2yFemaPEve8JfO7Cmjm88z
 TZJfdap1o9/vYKfl9MwdcMYvTN+NIHU/xfrYiDeoyIVxUaS9pPg91O8YOp4OHouQOmSZ SA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxujub1nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 07:38:28 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AL6IBHn035313;
        Mon, 21 Nov 2022 07:38:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk2twfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 07:38:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgKmnOgoxV0btA3AygHFtIWhCSsaQ030QGPXmnbH8kYH3D4MwOTWLQVTLZRjOmduDu5p4IYWXF9Nv1qvX1i2K0tD5bOIsA/2JBuWJ1KXSm2jkziOVUYzUxDct4P6vA7UWEaA1U4RiKp7NiGnkP0WMlswqzgY2kaM0/pIdHaieM54kLO7pAv2WiPqaUVTftrPt/TsFt4pt2R89RnaF+5/tOkZno8R99+ruL8cDLFlqd3yUXbCZwzb4sBxdYQRhcxoyne+pNXnG7HA3jMTshq9viIcuDM5huVlz5tFu40igERY+8HbIpJiQ3kEWu0n9uvINorAkWL9mFKzXNeZd9Nv8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GyugDkBO2NGbcJBC1K8ONyZ8gOPv53rJSYEZML/bxwA=;
 b=MQSVSOyaXCVMsRA2RbuLAndtOxbwKvb2vMbQDXqpoMUh4+YsSAzxE6YTrSyus3eWCfnMhTIFCMZQJj/bywUC5VeGppf7osaStdw+fzsfV55gy21Vohqh5hsL1vuYTWtoWpSWOiMtfZCJsisTi2bbZK7Dz6XM8AlRIHcLmbJiPSYMNbAYVLWc3H64GU8gUUdsqj0HYuofQ0dhWFRNVM5zAPccsxdy7yIOsJ3mTYXaqTrxAMONN/tYbi03dXXDpvMSxB7Bg8D9JiPngDB+YTsvXX0Me0AwCA7CMv6gqWwYpgeMYhfVuIOiwaBFCP8lbTReMw7zW2juUSBr7VpKl6U2OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GyugDkBO2NGbcJBC1K8ONyZ8gOPv53rJSYEZML/bxwA=;
 b=qH2gEwtAzuclZ9AokxqDsejkwOV3cBRMZdHXjNm8ON8G+ZD7VBKmDF7Tb9At4GwHr3yTdg6RZkRi/qLzRVP0VfzHpVguYDK6c5fW3E2IY6JZE7cyijxXkeekVOLTBF7CRaahZhrvw8A6SDAg9rdPC2mn81N5+aSDB8AZpqHN1kw=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB5006.namprd10.prod.outlook.com (2603:10b6:5:3a0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 07:38:24 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d%4]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 07:38:24 +0000
Message-ID: <c67e8d0f-95a5-a465-4b52-8ad6b78681c6@oracle.com>
Date:   Sun, 20 Nov 2022 23:38:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 0/3] kvm: fix two svm pmu virtualization bugs
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com,
        chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
        jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com,
        danielhb413@gmail.com, clg@kaod.org, david@gibson.dropbear.id.au,
        groug@kaod.org, palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        joe.jin@oracle.com, qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        kvm list <kvm@vger.kernel.org>, qemu-devel@nongnu.org
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
 <187668e7-f32e-b509-8ce1-4b35d98c7d31@gmail.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <187668e7-f32e-b509-8ce1-4b35d98c7d31@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR07CA0072.namprd07.prod.outlook.com
 (2603:10b6:5:74::49) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB5006:EE_
X-MS-Office365-Filtering-Correlation-Id: 06c19377-a505-47b6-16f8-08dacb935eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QwizExFFLseekOukyG1e669m+SEUnbnHg3CyfXeL2v7H/EzjBXBTcQPmAtV6+n4H0+7zulSlhWmIltYtl0ZEezVpxtnfTW/yp9Q2VeBkJc6DKY9YB8kxtYUp2TYCBZdzmTe496I9H2npxFlO4M7wEb9QCNbnRoEuMHqv9QkqIqo2TtJ1Fi3djak9VT0WAKV3L45k+iZY2tvw18vNvXTne114QeVvf51G/4RsUH5PYJ4FkD1dTnqZe+Tg/IpEdO/iHkEkVcnS7SNj5XwpTddeLflS0xCTtxWUr+9gNHgQOXp5Fy/bPNMfoemzb49U7nakIqzrS0L+OALPdL0Ms/2IJVeH4QfdbAwNbIZ+tAzQVOLku51BcXFd4p6KJVh5G3n+UrUlawQXLIkf77GGTwnurN4Rdni+PRYrTauGUY31IX73/ENfZe9qj8p2anVJZ61NEEFHa9Gx4X2F8bFY+zFc9d8n85Ikl5fHpOoH3x9qOfxEcfaCwT92z0wpm4bTVKzgaWewmf++WhnHsJsBb1OApCnr5Ha4cxpoPln6wYda/tt6XxyAsnXmgw5dyk6n/moarBqMocULh+ZCQQIJ02iZDFTX+lwR9HeCFIIGu505fUT1xABSfeZgCt09p0aZeEKSF99UZKyBrwCZt4ukwaGQp/G1cNgGYQgHQ98GFQo6ZtEyPNnHngsjsTG2MLm/cDQZ/RFLwBgb8XthjCS47bV7mE8psHE3UV2a88R/yzmEn0YkAqbP4Yj28iHapL3MEMsY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199015)(2906002)(31686004)(2616005)(66946007)(66556008)(41300700001)(36756003)(31696002)(86362001)(4326008)(53546011)(8676002)(6916009)(6506007)(38100700002)(83380400001)(7416002)(5660300002)(8936002)(44832011)(186003)(66476007)(6512007)(316002)(6666004)(478600001)(966005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFk2aElINGt1N291c1BLSVZxMDR5MWpxTnVUeTNacXI2dVJ3UWtUNFNIMW1o?=
 =?utf-8?B?RjE2TWJMQVl5ZURjemN0S29YZFA0K2R2TnZQeHNJUUpFN3o3WWUvSG9BUEg4?=
 =?utf-8?B?TnFEYmN6RndRL1NuYjRhY2I4Q3FKOTRQaWlGeWFta2Y4aXhoRyt1OG9nTE52?=
 =?utf-8?B?MmZtTkNkajQvT2RsRVhhNnBTelV4VTZrK05KQkRUOWpmNkhuNlRaVlBOODk5?=
 =?utf-8?B?NUdidy9STkNWNGxzY1lIRjJxSytVYVI1ak05Z1RoKzRZT2orOTJ3YW12cGlP?=
 =?utf-8?B?ZGtUMzM3STdsQnVkNHhkQUlvem95WS8rWjROUmFpd3pZRVFueEFFM0YwdVIw?=
 =?utf-8?B?MWdBNGdtWEJDbkwyaVRCKzFBQXJmWElXRzY1QWt5Yzd4c1JBaDluUWZtMkth?=
 =?utf-8?B?Y1FzeVFQTzVTWVhKZ1pORG9zZGtkUDFkd3FpaFR5eVhHNnhSSk5GTmFQKy9l?=
 =?utf-8?B?elVzR0VKN0U1dWplZEV1ZEoydXVUNWV5VUJKcC9MNHFvbkNvdDdvK3VQbGI5?=
 =?utf-8?B?bE9WWEVzM2ZGTmxWSUVKYmhqN0NTeXpHeWlUZnMzeW1NUkFqOUdOK2lOZ3hX?=
 =?utf-8?B?OVBrdWhjL1VvSm9DOW04WitRbnFyWHhITUFGQTZTMEpiMTZVNnE0Rm52eDN1?=
 =?utf-8?B?RTNSVVZyT08xelZhaXY3S0ZBRVc5SkNZdFRWZjdvbzlNMEJvZitBSjBLRlJi?=
 =?utf-8?B?RzZ4dTRUSTBhUFhZU3JRMmM4OFN2UU5NS2hxRnpCdmJaRzNlaXFTL0RVZnNX?=
 =?utf-8?B?VXNrY0NlbVBmOW85R3o1WUlwS2pUTzJJa0EwZUtzUlBnV1gzTHFNbUFvU1VC?=
 =?utf-8?B?eExUTUY4cGNPd2FKdHV1dERad0JsUE9Rclp4azFLbVJjSXhzSUszaXRJRzdR?=
 =?utf-8?B?VFZjWTRXRkZhWi9tN3h3VCt2S09CYURETE5qZHBuVTF4UzJ0UzQwRWE4TzFQ?=
 =?utf-8?B?NmhqZDdWU1hmRnFnQ1EvaDJPTmdGaHp6cHJVU25RcjJjQVRGNkpVKys5Ui9p?=
 =?utf-8?B?aVRwOWVrY2ZsTHNuUnVVeUhINEUzb1g5Y0d0d0dmWGpRb25wQ3YyaXN6dVVZ?=
 =?utf-8?B?UVpyQkJrMDNQL0lzbEcwMFhJQzd5VXZFclVoNlFFUVdwaWlLT0hMYTk0Zlls?=
 =?utf-8?B?cUZ2RXhjOE5FTnNndHBncFBjUGhNU21NSFNsOGxYNHY3TTk5WStKaFBzdUI2?=
 =?utf-8?B?NXQraWlZcnZlckE3eEM5T2VFUDhLbjc3Si81bUs4dlB5Qk1FdXZhYVdibDBI?=
 =?utf-8?B?dXROb0l4NXZvb0FxcUxSalhEZ0p6Ri9aMzlyRmgwbGxlS25JdStXWGRkNjht?=
 =?utf-8?B?MTNxTGdzejIrVm1OY3FZMnlkMlVkZWVFbThibGwvR2FFSXhSOHhleC9wNS9k?=
 =?utf-8?B?UENoUS9oYThwbHUzSjUrWndnTm5rbHhvcmdkalRkMy9NQU1peVJZQnhwR0tW?=
 =?utf-8?B?b0llUnFOYzlpRWI5N3pDays4UWdCTGJmbmQrd1RKeUtUWW5vSHlBaU5CNXBo?=
 =?utf-8?B?YSsxZVpHZUVWWDZUZkorQ3RNL2Y5VEpZb1NTUk1pQWtSK1poSXprYTJteGpn?=
 =?utf-8?B?cG9ybm44WjJiaXl1N2tvbm1lMkxxT0ZWTjNRUEloM0MrK3VFY1ZRU29uNWZK?=
 =?utf-8?B?UngyaWU5bU9NUk1vQ0RZZU95eDBtcDArYVlXLzc2MVZFYXJyVHhBajgzclpP?=
 =?utf-8?B?Nit0R28zUjNqMjN2MnF3QisvUWEvMmRlSWU1QktMWFAzbGUvc0dNUnlKRTFk?=
 =?utf-8?B?NU56ZjRQQmNPcmtNcGdXWWRiUXAzWjAvZ1pJajEwNDFzZWhaTHNWQUw4Q3cy?=
 =?utf-8?B?S1k5VjRlUVBhdlFsTm82bFpuc2tpNHhROWRYcERtSFVyTFdKZ3lsUnQvamdM?=
 =?utf-8?B?aHJudmJnL0txVExMRkdWd3QrbnkwWmp3WVYyWWtuQ2VzSENiZkd3WHdWU3pa?=
 =?utf-8?B?aCtpMTNLbTRadndKV21IaVk3RXN3aTFCV2pSc2NPODJLc1F0SWZYazI3bFRo?=
 =?utf-8?B?akhROEo5U1FYcjV2THVTbkswSWtrRlB6QXpsWVFxSmhtSnEzVDJlK1J4aFBP?=
 =?utf-8?B?N2RhelhxT2dLRVVweTF0clNwZFhHaGp2Ti9kUm12eGFNanE0ekQ2TmhGZTVq?=
 =?utf-8?B?emw4b3lhalhzcUhpdmg5S2FHWWRFd1AydG1pNVlmKzZ1Ykd0cEpMSFZ6WWxi?=
 =?utf-8?Q?YtAKeD7KVQAWExKx4k9NCZE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YnQ2WWZaNjZ5eFRBSGNjeVd0M1E5ZkxKRElOeWkxT1R3SnJIanozazVkc3Jz?=
 =?utf-8?B?VWtVZ3kySGRDZXppWmJEMHkydHJBdy9ic2ljcDhmNHFHVU5KRm9wb1pIQkww?=
 =?utf-8?B?NTJGLzRmY2JhWFJxU0VCVjhwdFh6S0ttY0piQnJVbEVXc2VHYW80aGZoa3RY?=
 =?utf-8?B?NVNyTER2S25SLzFXd2VpemdzaThObWVNVno4bU5nYkVhem90OHNKbldTRU9Z?=
 =?utf-8?B?VzB2ekI5MVNlMVZMbGIvNWVmMEZiNE5Hb0xBZXNKdk5peU5GUjhxOWYzQXpO?=
 =?utf-8?B?NnN6V2IzTE5rMWMzSGFpTkFMNmpTb28yZitOa3lLTFUrSEJQNE1UNldtdysx?=
 =?utf-8?B?NWlnQm1nRjQ5ZzF5Y1NlT1F2a1NySTdPSGYycllTMkhjRnB0eURicE5DeTFu?=
 =?utf-8?B?UzQyb0ZwVjFyNkxhaWd3NU1qV1M3bFFXRTJGUzRGS3hlcUdWazE0azNkYWg3?=
 =?utf-8?B?R2RaWmhhc2V3Z2U5SEN4LzdTZ09WUUoyTmlGbXB3UVNoMnlrWlVIQlZBUU1I?=
 =?utf-8?B?b0QrN2ZYRUhDR0RHbXhaaXNtKzRTMGFxL0hSbmF0UnlGMHEvMGduWFN1QXhy?=
 =?utf-8?B?SHF3RUhoKzFUOFdKRzRIOVU2TFA2VkZpbDhMaXlRSXR2MlRLQlR1U2VtMHhv?=
 =?utf-8?B?Tmh5MTVzaDJyVGEwbEpPTHpteDk2ckRrN3FuMDl6Vk12cmpsUWlVdjI1ZFRw?=
 =?utf-8?B?dGd6MjZXWjRPOXhuVEI0d1F4cmtHME9jbFFMbDlPaDRZbzBSenMwMVE1Y1po?=
 =?utf-8?B?UEJCeWRKNC9mVHl6dWIvVHExUG0zN3labmswdlBneGhLNGltVnp0QWZybjZ1?=
 =?utf-8?B?bzNoNXppR0t5dGFpRXNJT09XSFl5MG1wbkpyWHYvamV5UGdJR1htRGNhU0ps?=
 =?utf-8?B?K3c3RHd3VlI2MGFNKzltcE9lYlphaTdVNFZqa0ZIb0JEUFhITks0U0J3QzBQ?=
 =?utf-8?B?MDZPS1pBaURxZEM4V2lJcm15Sm1XVXZReFkrajg4L1BOOW9GM3FTcWtUN1lB?=
 =?utf-8?B?WVdqUTgzWG1wbTBFano2dGhIUlQ5UWxwWlZ0UlcvTm5QL1AzU1JpOUxjcnRh?=
 =?utf-8?B?bHUrSUhqbHdhNmhzMXZ4eEVWQ3lMRk5OUVo0czNWK3NNR3BTU2tpOXc4RkNS?=
 =?utf-8?B?eHQ3REZOQVpWVzNKc0RRYUY3RGhzVjlsUmhFWk4vcUJhL3JDdnc3elpmUnVZ?=
 =?utf-8?B?THBtN05xeFMrTFEyWTV3NU5YUU11bmZsQ2Nld1dEdFVlc1h6WWgwdi9seXNT?=
 =?utf-8?B?OGVHNGJXQjBJa1FNWEprYmRnS2VGZGJSWXNPcDVGeXJadllGdDRrZTVUakM2?=
 =?utf-8?B?cDdiSjJHaTZxSEhjcDNvN2x2RllJc0QxTFNUUzN4Y1JNb00yeGlEZHFpeFgr?=
 =?utf-8?B?WmN4eXBwcmxlclM3ajllMTZOd1VFZFdGd2JROE85M1NES2RvanpsNlVPaHpH?=
 =?utf-8?B?eWEyL3ZtbFVLdkVwcEYzWVJJZEdHTGg0NlQ3NmJ4SDdud01mY2pITXVBSWFj?=
 =?utf-8?B?UFZZNFpLVHJkWmRDZjVEVElRTktQRUdCQXlhZDVOWWNVdjJtZkVsV0E3bXgr?=
 =?utf-8?B?LzV6bWczUUtHa1VISkZtTVA3N29DVlFGMzUxVjZQazBIR2ZLNE13VEZkeXJs?=
 =?utf-8?B?Q2M5VS9rOGV2My9iV2pNb3JxOFNoNGNnNzlaQTdkcnkvQThpcmpaNFl5dFQ0?=
 =?utf-8?B?L2gvUFhIUnZCUnRGTEFzSXFaelBiWldzeU4ya3J4eUVzSmhQc24xMmpmdWhx?=
 =?utf-8?B?VC8zOVcvOWVZbVZIVk9mOVV5Y3VSSDJXbzBaTTZBbWhVNW5uVFlQZGttUlgw?=
 =?utf-8?B?MUhSekxXbjdNSFpPOWx6b3NmemhmZGsvdVBrSFd6UmxUclR4NnpmZ2QxYk14?=
 =?utf-8?B?MlZRN0ZNWFpQQk5TNXRaaFhQOUI2TUpVQWwvM2Jmc283R2ZzYlBYV3EwdWMy?=
 =?utf-8?B?QXBhTUlGcnk4alZxeEF4MzY3OFB4V09wZUx1TWpScnFpb2dpTnJUa1duVitJ?=
 =?utf-8?B?RFFEcytuM1RmNnhkR2hWenhrQnNkL2FzaHBMbEUxQXFvTUU5SUg2TW84Vk14?=
 =?utf-8?B?M2ZPa0pyTnloL0pDV1h1aDJvNGdQaDUvSHBrTTk3ZC9XZitTVnlrcEM0ekcv?=
 =?utf-8?B?bElhTXlWSXNIUW84SUVqSGVERU9uY1Y3QVpoV2hWUHJvV3AzVUxySmx5cVJo?=
 =?utf-8?B?OXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c19377-a505-47b6-16f8-08dacb935eff
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 07:38:24.3721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6C50psLKhNuVml7ylFnXjQl/ppk1zM7L83GqqelVPniVqXa8Ljkjvn6d13cGxc7KL+Q75mzjlTk4XZA+qa0Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5006
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_05,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210060
X-Proofpoint-GUID: _hDosV7cCCUfT6R1uOttFBfGzDGjhMst
X-Proofpoint-ORIG-GUID: _hDosV7cCCUfT6R1uOttFBfGzDGjhMst
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

On 11/20/22 22:42, Like Xu wrote:
> On 19/11/2022 8:28 pm, Dongli Zhang wrote:
>> This patchset is to fix two svm pmu virtualization bugs.
>>
>> 1. The 1st bug is that "-cpu,-pmu" cannot disable svm pmu virtualization.
>>
>> To use "-cpu EPYC" or "-cpu host,-pmu" cannot disable the pmu
>> virtualization. There is still below at the VM linux side ...
> 
> Many QEMU vendor forks already have similar fixes, and
> thanks for bringing this issue back to the mainline.

Would you mind helping point to if there used to be any prior patchset for
mainline to resolve the issue?

> 
>>
>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>
>> ... although we expect something like below.
>>
>> [    0.596381] Performance Events: PMU not available due to virtualization,
>> using software events only.
>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>
>> The patch 1-2 is to disable the pmu virtualization via KVM_PMU_CAP_DISABLE
>> if the per-vcpu "pmu" property is disabled.
>>
>> I considered 'KVM_X86_SET_MSR_FILTER' initially.
>> Since both KVM_X86_SET_MSR_FILTER and KVM_PMU_CAP_DISABLE are VM ioctl. I
>> finally used the latter because it is easier to use.
>>
>>
>> 2. The 2nd bug is that un-reclaimed perf events (after QEMU system_reset)
>> at the KVM side may inject random unwanted/unknown NMIs to the VM.
>>
>> The svm pmu registers are not reset during QEMU system_reset.
>>
>> (1). The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
>> is running "perf top". The pmu registers are not disabled gracefully.
>>
>> (2). Although the x86_cpu_reset() resets many registers to zero, the
>> kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
>> some pmu events are still enabled at the KVM side.
>>
>> (3). The KVM pmc_speculative_in_use() always returns true so that the events
>> will not be reclaimed. The kvm_pmc->perf_event is still active.
> 
> I'm not sure if you're saying KVM doing something wrong, I don't think so
> because KVM doesn't sense the system_reset defined by QEME or other user space,
> AMD's vPMC will continue to be enabled (if it was enabled before), generating pmi
> injection into the guest, and the newly started guest doesn't realize the
> counter is still
> enabled and blowing up the error log.

I were not saying KVM was buggy.

I was trying to explain how the issue impacts KVM side and VM side.

> 
>>
>> (4). After the reboot, the VM kernel reports below error:
>>
>> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected,
>> complain to your hardware vendor.
>> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR
>> c0010200 is 530076)
>>
>> (5). In a worse case, the active kvm_pmc->perf_event is still able to
>> inject unknown NMIs randomly to the VM kernel.
>>
>> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
>>
>> The patch 3 is to fix the issue by resetting AMD pmu registers as well as
>> Intel registers.
> 
> This fix idea looks good, it does require syncing the new changed device state
> of QEMU to KVM.

Thank you very much!

Dongli Zhang

> 
>>
>>
>> This patchset does cover does not cover PerfMonV2, until the below patchset
>> is merged into the KVM side.
>>
>> [PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
>> https://lore.kernel.org/all/20221111102645.82001-1-likexu@tencent.com/
>>
>>
>> Dongli Zhang (3):
>>        kvm: introduce a helper before creating the 1st vcpu
>>        i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu" is disabled
>>        target/i386/kvm: get and put AMD pmu registers
>>
>>   accel/kvm/kvm-all.c    |   7 ++-
>>   include/sysemu/kvm.h   |   2 +
>>   target/arm/kvm64.c     |   4 ++
>>   target/i386/cpu.h      |   5 +++
>>   target/i386/kvm/kvm.c  | 104 +++++++++++++++++++++++++++++++++++++++++++-
>>   target/mips/kvm.c      |   4 ++
>>   target/ppc/kvm.c       |   4 ++
>>   target/riscv/kvm.c     |   4 ++
>>   target/s390x/kvm/kvm.c |   4 ++
>>   9 files changed, 134 insertions(+), 4 deletions(-)
>>
>> Thank you very much!
>>
>> Dongli Zhang
>>
>>
>>
