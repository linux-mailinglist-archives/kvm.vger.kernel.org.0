Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024527C8B4C
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbjJMQbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbjJMQbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:31:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBD7C0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:30:13 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DE0oT9015808;
        Fri, 13 Oct 2023 16:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=8+d1pfz+O0vJADHtQrJ/rIDMQzQvs1tQt4BNhq04FMA=;
 b=pCO23+VErwpq4Cy17XEIk1QYWWFQlqgjGr+h61F3LcHBR5vHhMCG7jZa3k61rwGQKc5l
 1N5R4a1xkiryqr5x86lLJPsxehG8SzDlDILMP2miIxAhXT5N2LMmUgUYQFpvY/BbPSZU
 /o/wFNt5w5mHVY5Yup5O+uPJsSlXmdoGCYcDoxmni8ojv23Te5kKtg4j17Ya/g4zCSpo
 xS/1imywP5V/uSPco8f+xdcuwKGhBrdEj2XRffgSg7kJhHqGi5ZMHahOGjuBOG2ZA0sM
 LgaW3NBMsxSKYZG5V1gbwlUhWSrC5irBSAxxRepmEBvsYufgW13ebrKlmhAewT86rXmO QQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjx8cnff0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:29:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DF0xdp020228;
        Fri, 13 Oct 2023 16:29:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tptcjtj91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:29:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIlYHCTKHB8icCxzYOj6Y0oOBt4+QsmxGRR7Hy/3TpUfmSYNRACq0SjSK0eb4HY6WGt1vTk58/IRM0qRcbAZ2cDV429UzPf1kq2sp9OJ8VXbcn8oaLfUfUcq1RFCW/TC8/ojHF00Da7T5BBnJmpOwtcXP6Oma8QyXvQp81saVrh73w60wDOGDMDh2Xrl4nQuc0/81o+ho7jwwARbtPL9/sM3p3CAVQUYNcqeLg/T0ONptU/kDnkA1n1ZLel5slTOzlH5DFRxjfwUqZdscCWKNa4yFBK+nmQqx22H0JQtlvp8iARTue8p+jmNRioPWBLI8vicvjWkwhPyN2rNnrkPfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+d1pfz+O0vJADHtQrJ/rIDMQzQvs1tQt4BNhq04FMA=;
 b=Ya3QRnye4YPv5PMaJLkFR9mQKL0o8xXHswKiWymO6PUfK/GNCe5tYfPOYmx1qrTNmp2jVffv9JpfbMCVkqkmj46OEsiMhJ2pJbluBlSYeV+iTRDgXThLSZlZCamQv2zB9ThsPLPRti/kLBTo7hJsscq9oqLWKGMSJPh2PQgK3YIKvRO9nHtBo7gMxS8vgsm36WooIBy3sT0+E7giWBNLXCieLGELivlyiQYMPn+SVZgGpxySSvnTq8+2bA/Z7ADwFdbcISI2NTzQ3qDs+tIoS33E6NZ0KZOcplYKh2RDHL5Q+KpKbr+pLBhxBHR0lJubviSnTfQCaSGpeDG4tOL44w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+d1pfz+O0vJADHtQrJ/rIDMQzQvs1tQt4BNhq04FMA=;
 b=Zo0LZ/My9v63p589HkF4RYrhxTzO5whYlFFo/gBbRwfILYWK60XAZi53zGsPl3YVJHETXPFU842GJ4GW0E5zn72N6Wptr2l0+M0+05JnX+uBuF7UEP8ytJvVfdU3H02RX7qUEs6DU0qJm+PeNGYeyQqfH8E01a2OOi3vy1Iu3iw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH2PR10MB4295.namprd10.prod.outlook.com (2603:10b6:610:a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Fri, 13 Oct
 2023 16:29:29 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 16:29:29 +0000
Message-ID: <c806e0ad-5a52-4497-9d47-c414de12419a@oracle.com>
Date:   Fri, 13 Oct 2023 17:29:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/19] iommufd: Add a flag to enforce dirty tracking on
 attach
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
 <20230923012511.10379-5-joao.m.martins@oracle.com>
 <20231013155208.GY3952@nvidia.com>
 <fb94b003-f810-4192-8101-beef9fafc842@oracle.com>
 <20231013161651.GE3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013161651.GE3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::39) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH2PR10MB4295:EE_
X-MS-Office365-Filtering-Correlation-Id: c0ad31c0-183c-49f3-a33c-08dbcc0992af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yW2NeezH/E9p3F5ROiu9YHC4POaHrxZdUXKw15ftNJpAKb+HxA/rQrxJ7hpsILCC4Md8qiFkWe/vkeD8uGFGopTMiFH8rX+e92F3JAVS/JXiwQsa23tYtJs6/XptDgrp6YRESf8Op4qdcXg1p6FR8vi1/gORjUue6tLI6KB8sW8h/hfcJPw+D+4LtCZuaGzrVZSVge/4iKRteVbVgXedQqaX16yJ8vQiYvJtwNhcVBF8+NO02EkPh6UHBN62MZoODicbw6lW8uvyQY+/oibF868y8KfNBc6K/BpdFbwWKyS2Axrugy2X7FgKgDJOFWGdq1uk5qNNHxk0zMFIJYV2q7K1nw+Pteu3eETWLDiLInlhielLVL+byLL9j/8WGBYC4feAx1zbVgscdu0EYtyZUslUh5dgE6XmSMT3pKnhtgQr/RpEC1IHA6afTI5W1E+fjNeS8rsQ8BVTcjct6a3P1tNpFBYdtpvOI6UzMzvnBOwDjWbO9GSr20GIl6F1ejjHA7XU14Ndd1NMVQ+ITF+tmy4RsGa6963A/zbOspoH9Q7moWm/+YPLqGtwMZmu6nrmozYk5+1WPGpo1vrGrcsrIepD2AebqB3hquEX8VuYRe16Rcon8ALTAv56NWEf/peOCTBF//CcwBTVFYWMrq5/KCb4OrLxsBqZvp+9QcWfVwk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(376002)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(31696002)(36756003)(38100700002)(31686004)(86362001)(6512007)(2906002)(478600001)(4744005)(6486002)(8936002)(53546011)(4326008)(41300700001)(8676002)(6666004)(7416002)(6916009)(2616005)(26005)(66556008)(5660300002)(66476007)(54906003)(66946007)(316002)(6506007)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Si9pUThCb3U4RmNWaWFBV2phZUJFbUJyYmVBL2ZDQ0ZKQ3NGMmUrTVdWVmpG?=
 =?utf-8?B?NC9QMkxZQStyTkhOWTh4MklWWFFhUWx3ZkE4SnlSNmEzR2pwM0NvOFh3STZ0?=
 =?utf-8?B?bVVjOExNbVhqZmRPaVozWUIwT3NLMGRnMkpBTVVtM1lKUzBlL2NoS1pLZm5Y?=
 =?utf-8?B?WGVYNkVDVlVucWJxV1lUZy9NU3RaUzNIVzM5THZTOVhvT0R0ZFFXRWNXVXN6?=
 =?utf-8?B?MS9pR3pmWDBGYTBZMWxhSldzUUJITng4aDloWlFLSkxIT2M4ODlFWTdjaUNX?=
 =?utf-8?B?MEd4SXA4RWJhaGo2OGxwRDl3Mklub3l4R1VHem1wb2d6Nno3OUgxUm1YQVNR?=
 =?utf-8?B?ODN0NXZxUlFYWnhNbFRmeXJ1QUU3Nm9NNWYxeEJJS2VCd2RabU53RWlHWXFa?=
 =?utf-8?B?MnZUY0kzZEFTci8rNitiSncwYnpkK2ZxL3F5SWVidkdWaGMwTWF6UnVGa081?=
 =?utf-8?B?ZTE3bzI1Rkl4d3YrOE9sR25jTHdtR2FYRkRUQ2NXV2FIUzVIeStBVFppSDVh?=
 =?utf-8?B?ZlZ0NndhRHdhK2pCcEl5N0U2bTVSL2tnd1pkRFRsbUlwdlhsbFhzOGMrUDU2?=
 =?utf-8?B?enpOUVBkUkd4K0FvT0pxb3Y4dG5ieXJWSFU5ZTQvV3JwS1hGR1ZBWGdJWExu?=
 =?utf-8?B?cUxpaWJ4V05zK3R6R0RoczNGYlJ4UDlNdGUvQUpUVk95MGpaMWlYVVhualdU?=
 =?utf-8?B?QkVrRmdFYWZBMy9mbk9xYmp5WDJoUFU4ZGYzdVJaQjJYQUQvalh2aG50OWxx?=
 =?utf-8?B?cGpla1BpS1lnSm9YQktIb0JDRngyTXRpdG5HakRlSTJCWmducHAwVVB4bC81?=
 =?utf-8?B?Y1llNmdmTklGdXBJdGRzZC80dDJIek1mY05JYVNIeXk3VVordDdsTlM1YzFu?=
 =?utf-8?B?VUpka1luak5TSWUwV1VhZ0xxSFpaS0lUbHNlSFZFZ0lGRkIrU3pUT0NmKzZl?=
 =?utf-8?B?dHRmVnprUGNQbnJTZ3RYVlhXNGxuL0xIRzU4RmE3U1pNcy9oQTczNWlzRm1u?=
 =?utf-8?B?Y2tGa1k3U2pSK1ZKZUhWOTFONTJOY1p2VE40cGduV1lMZ1I3Vjl0L1QzRjZa?=
 =?utf-8?B?TEI5REtOWGxuWWVBaHZyVmU0L2NiZGZkOW41RmJZYUd2WlNDSVRtR1Zyb0xl?=
 =?utf-8?B?TnRxUlZ3RHRIbFdCSnJjUWc5KzlCa1ZQQjh2c2g0VnIyVFB2bXltbnNxRXB0?=
 =?utf-8?B?VXRNbElLcEF6RFVUdG1IZzQyWFg3YWlxdldyQkdVREVaY21mMC9xYzFWOGR1?=
 =?utf-8?B?R3d6QmJnZ3p0QSt6elkwZHdJV3p6djNDd2tmZW9Bdm8wUFp4R1Z2RGN6REtC?=
 =?utf-8?B?bmxPelBMUXFCbjBTU0J6RTF2T2twMmw0UmZaV0xlYmkxMmJrcE9iazYzZmdx?=
 =?utf-8?B?MXV2Mk0rZDQ0M2N0aDJFdFNJc2pjeVpwN01ra0Z0Y1FLaXBneFZwRlhEZTRV?=
 =?utf-8?B?UXFMK1dWTWxKcXlpNDNuNE1udlMxYldSSmJFdmI0SnduTnBkeVYwb3ZaZThZ?=
 =?utf-8?B?Y3NLSVpOSlIrQ1BIVGgzSVV6S1Z2blFpMStUWUJPa0RvUkpTaHlWalN2cGJj?=
 =?utf-8?B?MXRyRkZLczRBTHA5Uk1md3JTV2U0a0FaZGJJaFlWMGM3RzdKR1VPN2JDb0FY?=
 =?utf-8?B?Si9EYXZZY1dhOHZESXZrNWJwYWZVelBwbUpPYjRyOGswb1RNUHkwU25UTzNk?=
 =?utf-8?B?TmRxYVpWcFc3QlIxSmJER2pUUlJjQVBSQXJEYnUxZHZvd2dpdTI2RnpvbDdx?=
 =?utf-8?B?MEtIV3hDNVN4MXBnV2hncTdkM3M3L0dMYjY1ZXpsTXU2SmhXZGV2VFVRb3R2?=
 =?utf-8?B?MUNJR3dGWkhvUVdyZGZqTm1paldsM3FKbGtRVUF1QWhCQTQ1MDZFNXNwY29l?=
 =?utf-8?B?Q2Uvcjh5V3dTeVVVWUJiSWRKZWNIT3lrK29NdU9VOFo0QStITXdHYmVQM1Nt?=
 =?utf-8?B?RExrVTJBQlpxRFhQeFIxQjZiN09Gd0dhUTkwblFRemlRYWZsWUJiWms2OWY0?=
 =?utf-8?B?aFZKWktLbTN0akpkdlI1ZFdIMTZ0TlQydlk2RzhJcUNJTktjS0c2U0hRVDMx?=
 =?utf-8?B?Rm1FTGNwUTBvaW9ZVWdrMzdLTmc1dVJZRUo4c0xoMDhiLzhjbEM3Q3hHM3Vr?=
 =?utf-8?B?V1hES3RzdC85ZHYyWFJXNUY5SlZ3ZEdPMnJkVnNjV2tucU5NdDJmUVFzWUZj?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WThFa0tMbVpSdlBBZS9PREw5WTRwK0dUWUJYcUdVdEsrZUdHZk1ld2l5WFN2?=
 =?utf-8?B?VjZHa3UyWWdmK092MTkzWGNycXFwNjNZU3hYN3JGU0doc2kyQmk2VHBWZjM3?=
 =?utf-8?B?WDdyaWJHcDVOeTI4WlpTT1FFNS9ROUVubUZoeVFHeEZLWHNRakJCanBpamlI?=
 =?utf-8?B?Zlc2L3FGbkdFc3AwOXRYQ1MvZXZEaGdqWmxiWStjMlZSVENCc2I0blpQZktB?=
 =?utf-8?B?dEZ6bmpnSkg1RjczVHZBRmJYbGR5Tjd5T1VLeGM4ZUQweUl0UTN5dXdvTGJp?=
 =?utf-8?B?aFJmeGQzQWRDYlFab0Q5bVhjVCtlY1Q3aWpqUU42WGRTblhUY0pRdUwwTTJl?=
 =?utf-8?B?NnNZTHlYWEk5R0NmeXZsMDdlTWVGT3VNYnR1S3YvSW1GMXh6MVpUMDRQa0hM?=
 =?utf-8?B?UGt1dDdCTHlqYStwWWNkOHBqSENZN2RPR3pOR25MTzN2TDR1N0Rlc3Axanp2?=
 =?utf-8?B?L21lYUk0dG9jNmF4TDBHY2NnVm5wZXpLY0tmS2VLaUIxWFR3M09nc2R3K2Jl?=
 =?utf-8?B?UTVoODFlMEh5VXVFTTdla1dsLzFjY2pod0VvZE95VDV5SmRmcVhyUDBtZFVh?=
 =?utf-8?B?aEswR1F1K0llazhTdkh4amlZQ3VWbFFFbXd1OHgzQUtzb2ZXOGJ5M2dEaFRY?=
 =?utf-8?B?VzBOdml1cU9Bb2QyRU0rYk5OSGVvWEMyRHdqZk03eTJ3WUVTZkhpMHpnb2Iv?=
 =?utf-8?B?MUR6UjhYTmJoalMzMWpVdjlvajJNTW9wTTdQUWxaSFE3djJ2Sklhc0FOQ2NP?=
 =?utf-8?B?RTJzTVAySFlHZUlmQ25MTjlCb0huZ3dUM1lWRHcyZW16RzMwTXhPWVZoeHhY?=
 =?utf-8?B?eGk0WmNZZmhpa05udUtDaGtPektuczlaNC9JVklEYVRnR1kvWFp3RUw4Y28v?=
 =?utf-8?B?YThQQW9UMlhGUUo4SlBWTGFHUVNZTnFpUVZlWHc1WVpJOFJ5SkZ6Z2UvdzFx?=
 =?utf-8?B?MWdsbUxUOUk3blN3RDN6WU5VM0ZpVDFraU5xeHlEM3FKOEhnTUtCNkpaa3ZK?=
 =?utf-8?B?U3Z5ZkNyN1FsNml1cXVSM1dNVDF4Rmw4Ym0rb3lsZHVtcjJKQzJ0U3BTMjJR?=
 =?utf-8?B?NVJUQ3N4Si84RnBNNzcwTnpSMkJkS2U2dXNjenRPdmdQamY5TFp0L3JxelM3?=
 =?utf-8?B?dWd3Ujd0ZC9uenBTaWFGRlcrUTVnT3RDcXJhcHI0cDFnWFV0czJLcjg5VG42?=
 =?utf-8?B?Vmwwbi9aVFl6YmlpOHMrclJHdjlmQTNxWkQrVzNWalk1MjgrS1N6aG51NmFI?=
 =?utf-8?B?dWZrRjlmR1AwcExYNDlKdkt0eWt1K2E0UmxWejRUclJ3dlNKdzlOTk5GaFRl?=
 =?utf-8?B?eDE5bG9VWWFlSWF1VXJmVysvYmZjeGdrbm4rTHB2YXBiNnFYR0YyQUtHcmFR?=
 =?utf-8?B?WXJPMHZ5ZVJqaXgvN0hDL28zTU1kYldvWXlZcjIzOWNha05XVWUyMlFMZ0pE?=
 =?utf-8?Q?Xexi3wiu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ad31c0-183c-49f3-a33c-08dbcc0992af
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:29:29.2355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUVJOwvq5ZLzPTtB6y/jm624BCJVB//SirY5AF6/KzpIyxWJ2fHTWngS564/WbbDWMEVvDiflinUIjW9Py4HFLAk01LQtOEnKJ4ZsXKUjaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4295
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_07,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=928
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130140
X-Proofpoint-ORIG-GUID: C3FdOGZiO27symugmw9PBg-UBOLxLv-T
X-Proofpoint-GUID: C3FdOGZiO27symugmw9PBg-UBOLxLv-T
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/2023 17:16, Jason Gunthorpe wrote:
> On Fri, Oct 13, 2023 at 05:14:26PM +0100, Joao Martins wrote:
>>>>  	hwpt = iommufd_object_alloc(ictx, hwpt, IOMMUFD_OBJ_HW_PAGETABLE);
>>>> @@ -157,7 +159,9 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
>>>>  	struct iommufd_ioas *ioas;
>>>>  	int rc;
>>>>  
>>>> -	if (cmd->flags & ~IOMMU_HWPT_ALLOC_NEST_PARENT || cmd->__reserved)
>>>> +	if ((cmd->flags &
>>>> +	    ~(IOMMU_HWPT_ALLOC_NEST_PARENT|IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)) ||
>>>> +	    cmd->__reserved)
>>>>  		return -EOPNOTSUPP;
>>>
>>> Please checkpatch your stuff, 
>>
>> I always do this, and there was no issues reported on this patch.
> 
> Really? The missing spaces around ' | ' are not kernel style..
> 

I just ran it and it doesn't complain really.

But btw I am not doing spaces around single | ? Only around ' || ' and that is
quite common in kernel code?
