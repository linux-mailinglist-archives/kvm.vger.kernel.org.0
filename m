Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C5A7CC5C1
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 16:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344057AbjJQORh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 10:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344060AbjJQORf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 10:17:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ADEFA
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:17:33 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HEEjlj023104;
        Tue, 17 Oct 2023 14:16:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Eb4vA6opZ6loBhM71j8mw5FQ4Kmm/hZ8L4Ty6XC9W34=;
 b=gcZALyyG8BAdl8jDqMCRACVY3Kuevzd4etVUN+BoCBl6mamsU1yOV1bWO49pRxPVujlM
 efoyhanJBihkHJrRFIpvNFtJWUWYFiWGWAcJ8VDnPkm3H7jgVhexE5EEQbPqKpUr08Wm
 k680mh0cF8DnpDdnO9mC2u+g9+6gzRWRajiCOX7B5nbNn0zGK9ESA8FU4m9C21cD72U+
 rojkAds710ECcvU656z5PvX7fgFb+9Mj8E0Eub/W7lDWwQfwhv7+ZYkwvDdsczQhqtDg
 Lls8Qxl7p6ew3831tS66lCuTJ4ICU0FYXHiHj1lfCpYDUFRfL2W42U1G1iiEQF0ihGw7 XQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjy1d8v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:16:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HDebUo015400;
        Tue, 17 Oct 2023 14:16:53 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1f3sqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:16:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUQaKOgEg4f2K5sPSTvyGCKsxG4ZPfyZlx7sqmC6cncta24YR3C9C8ZYqHsbnYfs+5KSerT72AO3+ygewmr9vKZZ1j/+06WJdxMLtsxCX4tJCDPQVanUkiWPA6suiOFcBZKnlzn2pc8lbp2NR3oXyUXA30p1BAFSdvxZ3hAJyIF/OuNThI5Y6qbwOjCPVFyUT1GwQl5kzb02imJi8c2PVHBcMDsMIhFiMDwj092UfUdPjUZ8G8JMx0skmwVdzZ6q7R/0KuL6i8GeGlYkzqgxZtWSlm5x7rOi49EoWIQuAXyMVlSja1WL83NhoMsSnQ4mSCtC/b2rqeT+YBqJFgkC9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eb4vA6opZ6loBhM71j8mw5FQ4Kmm/hZ8L4Ty6XC9W34=;
 b=AuztdbSUkuwupeuTVI2Y7vJviCTaGHftfGb1xOks66b8OoxtRDtgN2t5BvKjYV/rw5vrf20C9Nu1Mf0YSBsh6utQG9XxtSBHEwKx0Amx1SIglhGrCdYudLibq8n80B+g9JBuwx8zz5KuowWHF/aPWxMuWlfj28vcdxyyE0PpYL23m6R3z32aeKrd8QLMwLxONFwnp/cLtVx/9IfsjE+yE3FtgKGTWTBJGqA2YrcTg4E7d/1guID/B2qBK3y6GoyVIIYMpFa4p/T5Zgi/9U6kxdwXBhhx2hb3EbBOZ1WQzPDwWg8+ZV+sRPT0hIwdClQlTZbezEzzt42HIqD1aTkE3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eb4vA6opZ6loBhM71j8mw5FQ4Kmm/hZ8L4Ty6XC9W34=;
 b=RrA1+53QDI8Bb+IxERTmsNUe5W3XDwe4qLJ1n5ObZvqducd9hZwT5NE4fvHmwgtO6vU49rhIaFHr4R3mRhacOqwzSpGp21+kSKfjko2vzyTdUtyh8ul8ZDsspLFdjf6iAoi+41Bpt8i078l+J/uB4ObflpJHh+OSQs7HmqXeLN8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY8PR10MB6779.namprd10.prod.outlook.com (2603:10b6:930:9a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 14:16:51 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 14:16:51 +0000
Message-ID: <8e5d944f-d89e-4618-a6c6-0eb096354e2d@oracle.com>
Date:   Tue, 17 Oct 2023 15:16:46 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
 <764f159d-a19c-4a1d-86a6-a2791ff21e10@oracle.com>
 <20231016114210.GM3952@nvidia.com>
 <037d2917-51a2-acae-dc06-65940a054880@linux.intel.com>
 <20231016125941.GT3952@nvidia.com>
 <3e30e72a-c1c6-55a6-8e52-6a6250d2d8de@linux.intel.com>
 <4cc0c4a0-3c00-4b29-a43b-ddfc57f2e4c0@oracle.com>
 <81bd3937-482c-23be-840f-6766ca0ec65d@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <81bd3937-482c-23be-840f-6766ca0ec65d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0056.eurprd04.prod.outlook.com
 (2603:10a6:208:1::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CY8PR10MB6779:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b61b22-c53e-44ac-87ed-08dbcf1bb4e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4QjHZo6RN8rqLg7kcJ8fUehuR/hHjquVoctOAhpv8e1z76FEPLg8/XrFPiXoBdOk7ullRCXE9LXRR7plaDtVZSJKeIMn9+WH/VFNYR4ta8PHoPId40Bv8CHtCSgs6t26PC6VIsBu3O/d35AJsJfAsaxBC/Cd3ps8DhEkPsnnUfql8cOhLNgFw17EPjTcmTAeU9f2+8SrtM9pgkSA5XnLlxK5mLIZtnBR+hcu5vVlgKn6gHgitmQe9hXTA5mVJ+vyK74Dk8Bh1d/qRCF3QNPfRagzW+kEK31fKsFDzeb7dfwU8SaeEnryWWfOl8Yj7jNHXl9O36cKCgCrTiDRLtexXb4xYH2TqEtqJ+w5gGolelyRfJDgXtKtWZDL7tiUOZsgP4zlqE365zmd17dmhF8nNYAhp3hx/eq6CsfyOwomV7bfdZkI5tMD1PDrj8b+E5Ddj/KT4KUkV8xkCap4yLh9dnRrNbtQfM+bYKbh0QeIBnAxbfL2qYEO0IdAq817TZNiGmhNESYuSLwaA5Br4k5B6ckWjggbH4t7AAJSgg+7mWOqc0yMHmyTyV0CJ5nT+Us0P+18TrN4h0bh/VCNS0/4BAbKHlFfbrs6ueRzoZY0kP77tOD7xdpCFOMZgK03YDnoqw+P6e4yC5+qqdR7CltfZ+FHHYh/NXMVHH9AxJHT6zM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(136003)(396003)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(31686004)(86362001)(36756003)(31696002)(6486002)(478600001)(2906002)(5660300002)(41300700001)(6506007)(38100700002)(2616005)(26005)(66476007)(110136005)(8936002)(54906003)(66556008)(66946007)(316002)(6666004)(53546011)(4326008)(8676002)(6512007)(83380400001)(7416002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1dGSHdvblVkNTdWSTF1ZnVCTXhBMDEzVldYNVVvV090dTRSWmJwZWZHQTls?=
 =?utf-8?B?Y1k4VEU4SDVSSUE5Q09uZFQzaS9VdWtyVC9rL1NnTVNnSkZLbGxaQ1oyY055?=
 =?utf-8?B?blBJeEdUU09pdExxN1drQ1ArOExDdjUrSUxSeXRUUjNxTGFIeE1SMkN4WDNs?=
 =?utf-8?B?TUNqU1dySElQZ0graE8yelRzV3o3MmZWTG9OMjcvU3BrOWo4ZHhIKzBpTjcv?=
 =?utf-8?B?QnVOemhDR3Zubmp3MGF6MkFPOXFDbnJ2T29XWmJWVk41ZHErT1FUOFF2U29H?=
 =?utf-8?B?akVyanBCUW1CUE1nMVpaS3hHT2F6ZU9tME5SVXR3N01HV0I5eEZncVlHcjhP?=
 =?utf-8?B?Q1A0Q0VpaHE3cWI3QTNKRVkyRVRTaytOdGZrQjNTbUZiVWlnaGEwd1hZU0JV?=
 =?utf-8?B?aDhDWGRzK29hbTd4cUdQVlQvUE9kWVFBMi9oUzVVdms2Sm9NWUZydWUrck95?=
 =?utf-8?B?S1ZLWUg5Qm02VnVUNmpSVEJhRGVYSEFyTzN0UnNpaVYrTTFZK05HUHZjSVdT?=
 =?utf-8?B?R1JkTlZGRTN4R1U3aU81aURjMVBqNXQ5cnNBQ2VUUlZUOHVrcFlzK0I3cGJh?=
 =?utf-8?B?U3RnVkozUldiNnZrSzI0UFBnOHNaSzhMZklyTmhzaGEzMmZyTk5HMC9uNW5N?=
 =?utf-8?B?d1V3WGJMajRXSmxwTzliUUl0NVFaMHBuNUF6MkJzYzNYZGN6bkVZL0hZK0F3?=
 =?utf-8?B?aHRTanlKa29MR2xZVnlHUUd3T2tEUTZ2Rk5RdGo3aFZTN2N6UzBDNHFidnpL?=
 =?utf-8?B?TzRwclR4dzNyMkpYUnFkV0NlTUVXNTVUR2oxblRKUS82ekNZbDdBNUNybnVi?=
 =?utf-8?B?RGhXQ0U0WU1nOGEzd1B1K0huSUNJZkJpUjJSbXdHK1I5cXZ4aXpvMUhYb29t?=
 =?utf-8?B?YlRqTVhKVytwM3FrcnJ0U0hSWCtMQ0pLbzdpdlp1SHJDUW5haGkxWC82NXRw?=
 =?utf-8?B?VEhmSTVSbXBOdVdic2hhVTZjOUJOcE40Z29SamIrM2FzTlkycXFiWU8wVG9h?=
 =?utf-8?B?RG1vaXFKNTYzckJXRkh5Y1N6RktXSmJTZ2hPS3dvQXVVcVFtcjN0MWk1T2xH?=
 =?utf-8?B?MHFxWXMyVGxYZEFPNUdMTHN1M0dhKzhBRmdnWWtwQjhLRHkveEs4NlI5TkM2?=
 =?utf-8?B?QXVBaFlMVWplNWcwekNoMjkyRWxldlRRc0FPeDNOdzJuYTFLdWJWUmlxRzlv?=
 =?utf-8?B?S25YbkFjelczcTdpK3FBbWNKOVlQdkZVYlRtKzIrS1hiTHVqYmhlbURPRmE1?=
 =?utf-8?B?OW1uWjVhdHRQUUkyM1JNMTVWWUVUTjhTZkhLMTkvQXorMmFUdFdJM2VrbjhY?=
 =?utf-8?B?aEY4T3kyOUNwVFNnTjhSWThtZ1IyQUhDSENVV1J2Sys2VzZhV3lxZTUvRmxP?=
 =?utf-8?B?U3Q1SmU2bW52WXp4dzJaK3FRRVhUOW5UZElaZUZYcUpMWnR3djlsUXZmdTBF?=
 =?utf-8?B?QmlxQTRUT1p4REVSblJ6SFpXeWxZZVZQRUllbW5GTzROd0x6SDYrdEJFbkxr?=
 =?utf-8?B?SmpodnJybGtIZkdSZFd4Mk9iSXpUZjdWU1lPWUtjMjRvNEo4SkNWdUROT2FC?=
 =?utf-8?B?OWNTV0I5eXBEbkNKQ1crYVZwdTdBR3JIVFF4K1lWMzBhbEFNT3pZWGlmRUZO?=
 =?utf-8?B?ZURJbXVJTlZwSENHV051OEFnWEE5bTJOMGx2SlRubGRqd2I4dnY5NGVlWG1C?=
 =?utf-8?B?bnlWdG1xSkx1VjhpREVnZ1Y0ZWp0eTduV0R3TmVoUDdhSXlvcy9mcWhVeXFn?=
 =?utf-8?B?NnA3ZXIyL2tScTd5VXZldnE4NnVDSGJqOTJ0R3E2dmZzSW0xWWkzRjdPMXdi?=
 =?utf-8?B?WFpGZ0o1c1VCV2d6UFFGVXJzd0p4bXNPR0JGQVdSM2YxbHhxQktOdTRQUnFl?=
 =?utf-8?B?amhlOXRjRE1rT1F0dllCdTVhekhsQXF5S2IwQ1gvWEZsdXlJNnFWRDNIRDln?=
 =?utf-8?B?dnR2cUtHZ0dTd2dBdDBvYXFVc21ZSjk5QXBiTHQ5T2VXRU9GMVR0MVNSVmxm?=
 =?utf-8?B?Y1MvSWpGYmZ0WGhQdkl0a05EVkxYeFZ2ZjNGd29tMmRMN0NvQXRnUGlVbzRl?=
 =?utf-8?B?ekNJVGprdFprbmo5OGUvOU1VbzRJSWRJN2xCT0loTFNiODA3TWkzWkYzS3Zx?=
 =?utf-8?B?bXAvMkhBR1loS0NyOTlvNjdRdmdtc2hlRlVmb094UWFpemNXL1UzY2t1Y1FN?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Ymt2SngxVU10Ky9pamEwOFgyaXprR0JtaUpnZUtPQnZaQjQ4Q0hha2VXcC9M?=
 =?utf-8?B?ZXVzQnlMV3pKekgwOUlpM2tEL2ZlZ1NMVk9LL29KT0tBQTNWY1A3R1V0VE9F?=
 =?utf-8?B?L2NDbzRhQ252dlFNN3A4N2RtZEZtd2tQMDdWUGlUQzlvWVZuYkQvQnB6YnF2?=
 =?utf-8?B?OWJKZmpWcURCM0Y3R0Z1dUgzZld6dGJOT0Y5NkdjODBaZWxVeGVhcmhMN0Ji?=
 =?utf-8?B?T0VHV2JvNElTM1lhZHlXcFRQbm5ad2oxb0ZuNUUxNStWcUVQWkN5KzloTDBE?=
 =?utf-8?B?SXRpV3k2Mm16V25la1BPdjZ6bEMrd1UvS1NzTmNhbVZWd0FwaEtQbWdhVkdt?=
 =?utf-8?B?U3pUb0Y1cThxNWNmcWEwU2lvZU04RldaUUhEaklENVdENlJ3Q2tTbHhycVVN?=
 =?utf-8?B?a1QvVXpXa2dwa0MwWGxtRkFjcGdNK0MwRW1EM0pmTGZSekppb2tlVGNlZGdw?=
 =?utf-8?B?S3MwejAyTDU5QmsyaldpclprMnZDNG5IVmpPQ08zbFlXZFBDYmV3VlpwazR3?=
 =?utf-8?B?Ry9PUU9VYmJDRVVVcERzaThidFVSNEM3OHNTWXVHWFZaL0lSdXRrUDhhTDNS?=
 =?utf-8?B?NHN4V3dqZCtDVnVCanZYRm9mRjM2ZzRpYlRFZ293U2dwNGZEdHNMdEZKN1lS?=
 =?utf-8?B?M2h2cnVITE1tKy9YTzJmcVJkY1JBQ1BhMHlhYml0ZDRQVEpYdUdkeFpKV01Y?=
 =?utf-8?B?aW50YlF1TGRLVkNQZWU1dEROeUJRMlVzS2xlRWErcW91ZVM0TzJDd0F4S0pS?=
 =?utf-8?B?NUJSNFBmd2RJbU14cE9nUnIyeDZTYmNTaEFjbjRQcGdiaE9qRmRHM29Kdnox?=
 =?utf-8?B?MVZQdDNhcFVnUjNFWE5KV2l1aEZEajlEQ2pWb1JHSVd6L21FMUllK3VkZmpJ?=
 =?utf-8?B?c2ZobTZuYTZxc1lJbisvSm9qaDlUeHZZKzZuUS9sSm5wc3VxVUhYWHE3MUJW?=
 =?utf-8?B?djlIU0hCcndXVnBCdjVIR2Z1TFlGTWoyRitJaG1TSlFOd2pzYUdiOVd3QlBw?=
 =?utf-8?B?QmtYZjJRSXFUUDdrbndQRS96T0JhQ0xxWmdnNVQrUjI5Zno3c3U4eFRYZFhu?=
 =?utf-8?B?bFVpT0ttNzlkNUNnU3ZVZTRCOTRGWk5OTkxNdmdrVERLMXVIbjlaNllxU0ZN?=
 =?utf-8?B?WFY0eEFDd3NjU2o3b1dPSVNsMU04NlU4Z0U0TG4vUW80R3BKWjlUdlg0TlZ5?=
 =?utf-8?B?Ny9qWnFaR01tRzhhSVlxRjkwVjFLZDVGcjRDakh5Wkp1N3VJblcrZ2REeXFh?=
 =?utf-8?B?VkFHaDhSSDVJS0oyNlN4cDhUb0VKcXVxdnFUWkJ3UGVuQk5xV244dXJFc0Fw?=
 =?utf-8?B?ZjBKOTI3L0VPc1JOcUpFcmg1Sm5ZRk1hcHZDR0d4a01xS282dE9jYldXRjBh?=
 =?utf-8?B?a0d4WlJxYjBPOTJJQUdRQ0ZCM21BbjBKWGQwMVVEbklrUTFsMnhVdjUyQ1J6?=
 =?utf-8?Q?dtzz+Jx2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b61b22-c53e-44ac-87ed-08dbcf1bb4e1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 14:16:51.0983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9i2PMdHTBayX1hmIPbckbEAzT0Iu1Kywnwkv/jOdNzJ0U1MB3wce38e8kyMvcZ1lvxOlkoSfE8sPvdwK7p+L1Wg73BgBQdLAYZs/ipF0tsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6779
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170121
X-Proofpoint-GUID: LAOTLb7RZ9PBJZZUMDDviQka6-fJacP6
X-Proofpoint-ORIG-GUID: LAOTLb7RZ9PBJZZUMDDviQka6-fJacP6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17/10/2023 13:41, Baolu Lu wrote:
> On 2023/10/17 18:51, Joao Martins wrote:
>> On 16/10/2023 14:01, Baolu Lu wrote:
>>> On 2023/10/16 20:59, Jason Gunthorpe wrote:
>>>> On Mon, Oct 16, 2023 at 08:58:42PM +0800, Baolu Lu wrote:
>>>>> On 2023/10/16 19:42, Jason Gunthorpe wrote:
>>>>>> On Mon, Oct 16, 2023 at 11:57:34AM +0100, Joao Martins wrote:
>>>>>>
>>>>>>> True. But to be honest, I thought we weren't quite there yet in PASID
>>>>>>> support
>>>>>>> from IOMMUFD perspective; hence why I didn't aim at it. Or do I have the
>>>>>>> wrong
>>>>>>> impression? From the code below, it clearly looks the driver does.
>>>>>> I think we should plan that this series will go before the PASID
>>>>>> series
>>>>> I know that PASID support in IOMMUFD is not yet available, but the VT-d
>>>>> driver already supports attaching a domain to a PASID, as required by
>>>>> the idxd driver for kernel DMA with PASID. Therefore, from the driver's
>>>>> perspective, dirty tracking should also be enabled for PASIDs.
>>>> As long as the driver refuses to attach a dirty track enabled domain
>>>> to PASID it would be fine for now.
>>> Yes. This works.
>> Baolu Lu, I am blocking PASID attachment this way; let me know if this matches
>> how would you have the driver refuse dirty tracking on PASID.
> 
> Joao, how about blocking pasid attachment in intel_iommu_set_dev_pasid()
> directly?
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index c86ba5a3e75c..392b6ca9ce90 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4783,6 +4783,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain
> *domain,
>         if (context_copied(iommu, info->bus, info->devfn))
>                 return -EBUSY;
> 
> +       if (domain->dirty_ops)
> +               return -EOPNOTSUPP;
> +
>         ret = prepare_domain_attach_device(domain, dev);
>         if (ret)
>                 return ret;

I was trying to centralize all the checks, but I can place it here if you prefer
this way.
