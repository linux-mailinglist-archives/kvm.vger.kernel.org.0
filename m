Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC39C51BC95
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 11:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354664AbiEEKBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 06:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354649AbiEEKBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 06:01:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0CA4F451
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 02:57:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24588rUq025194;
        Thu, 5 May 2022 09:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=VPuiUDtPLM1cwgrdQTzLSX3MEleNsP6yO8c4Td11XSU=;
 b=z9nETnrD0w4um/r4fNYwwLuMCT19u3IZRokFGm0unnm2NIYefQm0UcpdPwX1TwI524n/
 ElfqJG2jlYsWNKO96PjqjUUUlVgvIHjzPysKMLRNUv0o6raZq0Wv3ynirsYTq4MOEukL
 L7U9SkX+3jag2FVndWQ5HvKKcvAjsCZVqSEXqvonofrO5yjkzoXqi66d3IsbnfhHqrB5
 PQZAapOtv2nOsqAd5qlYj4FYiG2LIatfoY17F1buNaK2pFJrwSJIvKyQHsVK8IXsp22i
 cD6oI0+2Mrz6lx2msjNNr5bMa5/pQ8JWW+L6hHS60EM/3pVbmU0dMQcVKjO6mtUX/+99 1w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2jv19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 09:57:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2459tRj5028307;
        Thu, 5 May 2022 09:57:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a6rdkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 09:57:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2LgrmC3fPNphWXpZhw5SUOJJ5+bjtAMwuc+xsaMPzE5rcR7rx4ARG8/IVGR1PwNqxybCp/apWvL0LIMFO1HHFjemrOUxf8rxBSnRbKDM5APz8gzewq7K+TQTiYxxW9eHRI9HsQkwYJAmGb2noJHe9HvP8A51ZS8iCyV1zTxyRB0kOisK1MKTFf14G9Y0pMotNyt55y49wXeO3K/8H2MChwIIwQxdiq2fB8m/m/HmeQcvgzdTF1XBwn0U1uo6uBuYb8B4TOANE6sTj25Q8F2rGcOkLUPqUtYJkLjgGkB6VLh8R1LutNL9oIlMhgcvAViEY6zn7dzDx/SF0iW6+l2yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPuiUDtPLM1cwgrdQTzLSX3MEleNsP6yO8c4Td11XSU=;
 b=Z+LwSfiir8mXVRNqcZIndo+JzmbnnzSFZt9BpyOmFtmBFt9kn54UBTyInwbjwuyTaiVXvIiV6ZFcdGklq/w+cFdbCUIQMV2HjqcX+Ohdtkg7KcuQDhgq7rGkZ0zti7+M8iH/xDNSL4jAiymnZ9b14/GY5gs0iMgpC5UoqZzKUEsUYklx8adBKzcI213oMjTbOOOiWZDTbD8f8lMCFTM8YmvCuXRemXhzqCNKQnuK8QlIS5Vo9gbYUzE9/x6QiASOjlZ8CBC9hMf9QQpCjdtUm8OZ2qYI8pbQ380r+Cv3YhylB0nKsvffkwbkNiRXaQr4+DpKvrCwPHszvlFWyT0QKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPuiUDtPLM1cwgrdQTzLSX3MEleNsP6yO8c4Td11XSU=;
 b=nS9UiOBEVmXHU/0IfC66sH9e72mEW65LUt+4JAkItsjZgvVEnpupJwK3hR8o7eshyxMuMcac8cMrdlezY/omYGUcyT1GhHBn8Sd3XJi2Q/ICSIbzGSKdQbB4I/CLLXxD9HRP80rlSbQ1veXPqOkaOXW8Uohnbm3V1eJnrMmjvwU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 09:57:16 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 09:57:15 +0000
Message-ID: <14d29e7c-26c5-2e22-bc67-f0c9a428d750@oracle.com>
Date:   Thu, 5 May 2022 10:57:07 +0100
Subject: Re: [PATCH RFC 04/10] intel_iommu: Second Stage Access Dirty bit
 support
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>,
        kvm <kvm@vger.kernel.org>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
 <20220428211351.3897-5-joao.m.martins@oracle.com>
 <CACGkMEug0zW0pWCSEtHQ5KE5KRpXyWvgJmPZm-yvJnCLmocAYg@mail.gmail.com>
 <f90a8126-7805-be8d-e378-f129196e753d@oracle.com>
 <Ymwsl5G/TCuRFja2@xz-m1.local>
 <62f26667-5ccd-619d-2e0f-eb3a3f304984@oracle.com>
 <CACGkMEtVVmz7fLYSSE+OWA6VsjUO8R4EOHDH-0o=97ZJkXDJuw@mail.gmail.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CACGkMEtVVmz7fLYSSE+OWA6VsjUO8R4EOHDH-0o=97ZJkXDJuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0214.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e7ba3cb-2f21-45f9-9de5-08da2e7da259
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB53203E31417E8C9322116FD4BBC29@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ATIAf1FlWhON0TlGMaJRN458w5pXWqdqTeAVG1wOcm/+dM6GgX5ZlIsx4b1LJ/48FzeIKSFHOrOEP/QtMGXY+1rxlO/W8/I0vH3rID9rxCWpX1L1EtYPemH6iqHOOiEtBJMC5FwqMDOkct9DSRhFiwfJkR8TvlHl2EGLnrtFlg6IEAL6V+/jD3NBfY/UXEPIZiL70g/kl8hKp0bs4Bq2DxHR5+c05IaBIkztEYGsyVRpUt2lEIg3NCzNvG4O117GtHRvrRalu3Spko3KK1kGdBPYJ38itSdvXXD3a+PdvwSktPrm2XLthIDojuWmmLf9pwcUeXBojorKq5EfS48/0p8VDpdYTXxDsdLNuvzsucUN2TX8EjWFjB3DKLF7Pz8CrJifY7t5Vh4CtRBsJUrkdj+o0HjwaTmk2rSv2sTxsfbwQcJ+lC82B7rtcsh6ie5q5TgP/WT4Nzg7UOKbUwnQAUc0uPd8wFcqXzzIXKC9bvPYe4Dl4xtnaKL03rCjKybZ+Ajtk4tP92xcqGxGhYpmvMGJoiw9XFI52pZWebXq+bgtoBylFGqAWRO4dqwPtuNa4uBfDNnWtH+5DxF2X6gRNtuUWGUVRDUJGTuspXHVHW09L7JIvd+Z2xyI8XrA/2ETt9IBzOsG3x/w5WiXjgqCSJr3ibAzLQeJwu2m6pnNYoEi2hPelYqgxQew2WXurpVCfV3w24FO8vFKOZX1p2R4l2I83ol2vA0VAMQSqZNgCDs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(53546011)(2906002)(7416002)(8936002)(186003)(36756003)(66476007)(4326008)(31686004)(2616005)(26005)(6916009)(6512007)(6486002)(54906003)(316002)(508600001)(6666004)(5660300002)(83380400001)(8676002)(86362001)(31696002)(6506007)(66946007)(66556008)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGtwNTM3bUlaQjBjOU00QXZva2l5RlBpRzRFbGlyQ1lqby8yNmN0SFFuMmtQ?=
 =?utf-8?B?Z1BaMHlqWURiSDVIendFalJTZ2NOR3JtNlM2RHN6ZkFidnFNQ0h5d1YraGMz?=
 =?utf-8?B?WnM3S1diU3REcndvaFF4T0RnNisxLzdlTnI5eENZYUI4bnRyTXU0elNRYktS?=
 =?utf-8?B?RVFJZGhMblNuOHBtRVVicXR5ZUhmUTdRWk9iLzBPcWxEYURsb0R1eFZlYy81?=
 =?utf-8?B?SVMveWxoZzcxQ1lxT3NQMUdhTXBlS3lJbGVkVnpzN1k2aUtCZ1ZGQ29YZzI5?=
 =?utf-8?B?dFEvU2tzbG45R2lkYVhsY3BreW1KQVh2R2RYSzVYVUYxdDVzMjlEdU9vcTJq?=
 =?utf-8?B?dzRBYStCSTU0ZnN5QTFwYm5MQUtHZUZaenlHYXJPZlRFbjFGakV0R05TU050?=
 =?utf-8?B?TjBSeWFXTFRNbEN1TklDRERxaGNiamthbGMrWFc4TzhmM2R0M1VKNmRsYmY5?=
 =?utf-8?B?VUMxZHhISjNCZy9rREM5T2ZEQWpWb3MyblphMUVmbHVQQ1J3ckdBQm1mcXVW?=
 =?utf-8?B?OXN4N2pWUGhrWlFXVlVDNmthKzhwa1dsSjhqeVNGamNsa01McjNnN3BNK2xQ?=
 =?utf-8?B?MXBrc2lQNkh3THVsSEZWalRHMWlvTk0yWHh6bGdQakpGNVY2R1lQUys2UmJ2?=
 =?utf-8?B?UHdvQmtJWjFCSVBncWZuQzAwWTNLQU1NdlBrT1JDdk5vcmRJTExFM3RKN0lC?=
 =?utf-8?B?M3dyM2MwUEdHb1pUTDZWaE9zTU5uWkRMVmoyME5lNlA5WGhGay9qR01WRGlD?=
 =?utf-8?B?cVF5ei9xbkpVK2tLT0ZyMGlXRlhzczQ5T3BweTZQWCtjWERHY0w2SlZMeVBL?=
 =?utf-8?B?dWJWY1BQcXBUUEtWL09uRUFpWWNnajB1eGVpcUVBT3pnYUlUb0FOekwybkYx?=
 =?utf-8?B?TXdCVXBVWXB2ZXZTM0lYbytKb0Q2aS9pTzUxR3BybHZUUzNqOEZkRVAvTHBH?=
 =?utf-8?B?RVUrK2hSVXpJK08zQ09rQURhWUZSRXF3cnV1VVlWRzZtOC85UWhKQ1M5eUFK?=
 =?utf-8?B?MWRWbTl3VlNMODRZMStxRnMya0luSlByWUg5V3A5c1FJTUhIWmoxWjhFTzVQ?=
 =?utf-8?B?ZkZOMUVrK2ZEMnZxemR4S1ZiQys4WFZ5dExnSUtTOVBxNFJYNHVtL1VkVTZq?=
 =?utf-8?B?R0ZXTEozQVFiU3N5cDZmenh2d1JPRENZY2FESmlwbWRtQksxaEZ3bTBJM2dC?=
 =?utf-8?B?TlFhNlRsYzE3TG14M2lHMkJURS9UYU9yRmRKNzBZUS9FcnVTdmQzK0xQak4z?=
 =?utf-8?B?N2hoRUora000KzlwK3ltQUo5Sis4RUxSUHNvQjgxUDBRa005b3NNNVovc29I?=
 =?utf-8?B?dUdpU2g0L1oyL0pISFpRSXhkYUc3YjU3eFZqYTBoNkZ5ZS9mMGthMEdZbWZS?=
 =?utf-8?B?aDNuN1FBYmZXNERTVlNET05GVUVaUXh0ZGRZYjhpOEtOOHVJYzJxaXU5aVRt?=
 =?utf-8?B?d2NHdFF2SWN6aTd5T3ducFdlU3Z6UlBhNHA4ZEFhQjUwYnI0djhWY0NhYkhH?=
 =?utf-8?B?NzVWbHpwTWl4NVoraE5zM01wSUVHWFBJWW1jNEczWmo0TEhEM2k3eG9uWCsw?=
 =?utf-8?B?S1lGRW45d2ExWk03RUdjbGNoOVAzWXVQa2xOMGtRcFZycmNrWVZmZkJJbEx0?=
 =?utf-8?B?N0laUi80cVNEOXE0VlI5MDlWd3BwVnFSc2tHekgvM2I4bzU0ejRPdGsvd01F?=
 =?utf-8?B?by9OanJaWmtOSmtRWG5CZU1KamttanpPZFo2c0tuaDNZaGxSY2J6T2lSTmJy?=
 =?utf-8?B?Y3lTeEUva0VCOWJEVzgzVENBdm0xb2dhWjd5R0tWeWNlemRUbHRWdmtMdElW?=
 =?utf-8?B?NFplYzJYVlB2T3VuZE1xUmpuaDZrcjFITTNmdmFyZGp4bFZyVjBubEV0Qll2?=
 =?utf-8?B?NENxRG5RNEYzRTdQQW9EdkpwaGVRMm1zVVNkUWJzRk9aVWl5cWwxWUNKNGhM?=
 =?utf-8?B?YzlWNTBqQlNIQWhLaFRCWnh5NjRwRStBNStDOG5BVHhEbE5pdGZQbU1zSGtB?=
 =?utf-8?B?bkJFTHlLNG1Hb0pJQlRaellDU01XQ2VkeHdqTkljdWxBSVlPeEI0YWNEQmRN?=
 =?utf-8?B?V2dONVVjbkdGYkhhc3laNlhoMXN5NGRCQ3BoUVNYTzg0c1BDalVYcTdNNldS?=
 =?utf-8?B?VHp4aUlqeVBWTVZsNGhxOUV4SnZiY2JmYlVzQzJuQldEaWlRTnQvM1VaNjlB?=
 =?utf-8?B?NVpLNHZXZ1NKVDZjcjRvZzQvL1M3cDM4ZjgwcDh2eGw3TkVxZkMwV3A0Wk04?=
 =?utf-8?B?bVRmVzlESTdPZ0JMQ1dZd0RyWVpSSnlKNUxxMVFMVkVibjlOaWIrek5mL1J1?=
 =?utf-8?B?d0krbEIweGV2ZlNxTmZieUltaW5xQSsvbnBXUGd5V29LR1RUenlUajlPQW5p?=
 =?utf-8?Q?LOxJMiWFfCaWT+6g=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7ba3cb-2f21-45f9-9de5-08da2e7da259
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 09:57:15.9042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhkZtclAVBJmqw+zMii9ut+GMiDyN/7jqRCRLRQKjtZZ1nkSgB++aP30gRdOw9vgT5hA3Jh7e/T6zMgX7hSYwab009A/gLmxIl12w/QaY+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_04:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050070
X-Proofpoint-GUID: kdBI6Rj2nNFGsA02N6RpjO6vrvFm_WcJ
X-Proofpoint-ORIG-GUID: kdBI6Rj2nNFGsA02N6RpjO6vrvFm_WcJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/22 08:41, Jason Wang wrote:
> On Wed, May 4, 2022 at 4:47 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> On 4/29/22 19:21, Peter Xu wrote:
>>> On Fri, Apr 29, 2022 at 10:12:01AM +0100, Joao Martins wrote:
>>>> On 4/29/22 03:26, Jason Wang wrote:
>>>>> On Fri, Apr 29, 2022 at 5:14 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>>>> @@ -3693,7 +3759,8 @@ static void vtd_init(IntelIOMMUState *s)
>>>>>>
>>>>>>      /* TODO: read cap/ecap from host to decide which cap to be exposed. */
>>>>>>      if (s->scalable_mode) {
>>>>>> -        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
>>>>>> +        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS |
>>>>>> +                   VTD_ECAP_SLADS;
>>>>>>      }
>>>>>
>>>>> We probably need a dedicated command line parameter and make it compat
>>>>> for pre 7.1 machines.
>>>>>
>>>>> Otherwise we may break migration.
>>>>
>>>> I can gate over an 'x-ssads' option (default disabled). Which reminds me that I probably
>>>> should rename to the most recent mnemonic (as SLADS no longer exists in manuals).
>>>>
>>>> If we all want by default enabled I can add a separate patch to do so.
>>>
>>> The new option sounds good.
>>>
>>
>> OK, I'll fix it then for the next iteration.
>>
>> Also, perhaps I might take the emulated iommu patches out of the iommufd stuff into a
>> separate series. There might be a place for them in the realm of testing/prototyping.
> 
> That would be better.
> 
OK, I'll do that then.

>> Perhaps best to see how close we are to spec is to check what we support in intel-iommu
>> in terms of VT-d revision versus how many buckets we fill in. I think SLADS/SSADS was in
>> 3.0 IIRC.
>>
>> I can take the compat stuff out if it's too early for that -- But I take it
>> these are questions for Jason.
>>
> 
> There's probably no need for the compat stuff, having a dedicated
> option and making it disabled by default should be fine.

/me nods
