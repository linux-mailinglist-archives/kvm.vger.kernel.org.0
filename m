Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2419A7337EA
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 20:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjFPSLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 14:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjFPSLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 14:11:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED0626AF
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 11:11:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35GCiYhN024667;
        Fri, 16 Jun 2023 18:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=sr7yE+VkPEyRrrrXyQzP/yo9AVKB5rHT9piW2BcUj6k=;
 b=nucUL2fAVRIX+kb/CiCEbvWfGGEEO10qZ8JuvrUUN+59Yp6zgxCc7IGk0ZlUkwFqBfQG
 t11ZvZ+YpBtkjtckkWwIywQWNWJDmKw8FCWMVuVer0w9+CuYstmOcLwvQz0y62sWFYML
 gVYp+9qP0qUgY6wEOI08+A5fopBEUnK0JO/nb5bLCdUcN4U66LiRKsHl8Ec6BZSK2puc
 deMJo5pxfxTpVZIKusMBrFbRFOhkDwZFBzNTx3wxODVJwY0sg+wKhLVJX7Icv6VmgHo0
 0U1udUGuvlrLrNQZZAuoCYWBrJ3CCG/oQEWKZLtKxgR83Y4y3gArmJrQaPndI5UmNoB8 qA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hquvu5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 18:10:33 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35GGGReM040492;
        Fri, 16 Jun 2023 18:10:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm88719-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 18:10:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYjuO+NwtvjqivfDmhny5LoYmbwZGw+LvuZRReCvxvhPH5OTf7TKsAUY2QDk6mGMqkzWIW7/mIpyMWarAQ4t0l5U40U9U/BR8RWu6nBuTWDlNkPggSlWQPR8pzuqlyFPQcWQKQva7hVbTer51KinKm47gvjGcW4slXUNTmeP7ylyLrZDpj4uR/yWQtx/X6ozp0AP9kZ6SYGsdH+Jnr5CCALh7TpEdFNLSbyXfdrO8VOZKazITD6EYYx0dau15USDdb33YI43Va8MlsQZ3Zq4B69IikquOIsArXtoGFEbutuQjfCrkG1PNkJbF64NeCK4A3ewth1XyEbjHKnYf415BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sr7yE+VkPEyRrrrXyQzP/yo9AVKB5rHT9piW2BcUj6k=;
 b=jisc8n2Fn7V/i3EWfi9paCR4Wqsb4K4a8bsl6p9D+H3vxn/DJb8x/ypWuUy2qpOsiz0rvew1YEDPsFBAHnjdCwid8PIUtwez9AVTwavXVISMx+OyerDMv7rWq9R59K1YPmufFr2fuYpRl6HJi0AqlborS5Mmy+Ah1vAYq3fdsow7m2jbLiR5int4ZsVX487l6Ans0vEeIFZFEKQcySo08AWLcb3CDg24cP8A21BVQUupzi7A9Tq39KzPgDdz1RljRNmKQd5SeHSjXS08leikqO+8D328UIIC6SrCw8PWGwMoqfOUUCv4GSIS4fFlKGL9XoUbUIATe5oTgfxfArAVNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sr7yE+VkPEyRrrrXyQzP/yo9AVKB5rHT9piW2BcUj6k=;
 b=PuU04d0ySZr9DhcNsroRrqxrJbipgW/yv8Dvf/6tqzDnz+stTXlzWVvmiJ1A750YCw2xOMAQmcqC49EyHKTCfEV0nCpJFxr3NZis7YXrPVSQ/yresQA/TkEBL3SDco28v1sStJu25pzOYGPZePB00BoDrZs1od5/OAQbYRwvlok=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CO1PR10MB4545.namprd10.prod.outlook.com (2603:10b6:303:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 18:10:29 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::f7ba:4a04:3f37:6d0f]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::f7ba:4a04:3f37:6d0f%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 18:10:29 +0000
Message-ID: <154bf412-95d3-b069-89a4-35fc7ed11108@oracle.com>
Date:   Fri, 16 Jun 2023 19:10:23 +0100
Subject: Re: [PATCH RFCv2 22/24] iommu/arm-smmu-v3: Add read_and_clear_dirty()
 support
Content-Language: en-US
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-23-joao.m.martins@oracle.com>
 <c4696aad77ef49e7b3c550c19b354223@huawei.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <c4696aad77ef49e7b3c550c19b354223@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0141.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::46) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CO1PR10MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: fb353521-7221-4ace-863a-08db6e94f7b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U2iBz2XqxTNpWdxTNzoXWrVFMWePTERaYR4mR6fRy8qIQ2zS4tUqnbBcuGRGYGm1PfvNR7O8IbHSVgxql9LRHs/a6eAnJncv9UGGrCeMBOpLr8kM0rASU35WodevtpC2nogCxcFowbaa+AN9jNNmR/xP8CWybTkiJQkDefOYwR6AhATWK65nugojx5V3vZwPLsfCzpYk8/IycZjlW+RKvMevLqVEP4pl9MtOpxNj/6svJ1w0KncSC3I2DY1bcH5xIWr6MUZxrHMMIRedgjkI1tOWKTEh+UBfTKXHtM7iCzaS7A3Z8qVjLm9v/ZD6M47VbDmieF1NWKAILC03a2JF+am7KEfnQJD9zH3tgDDM/7X1UZ/QieFyg0SeBx8znHTPlQdbf+wekvx9tQG3DoW/K7bXv30ZcWGbYhYmsC2ur4gNThINiPbuPYG0sjJq2o0iV3fOjKm1ckTkJFLycbPB5tDTfhDKIcqfty0cUkQms5ZfN+EjAzEn75lBAGqDEdORZUF2uwAMCv3eewTgsDdXjOOt+B4FEIzI5uLg/Z8bx1IWXW3DhUYI0fP8USS+JNMoVw56lHZ7NjVbS91MiTFUw6gApgDTn9tRCv7Pp7cmaBhVHinA2EUioCfm5jR1K9CK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199021)(2616005)(186003)(2906002)(83380400001)(6666004)(66476007)(66556008)(6916009)(36756003)(66946007)(41300700001)(8676002)(8936002)(6486002)(316002)(966005)(31686004)(54906003)(86362001)(4326008)(478600001)(31696002)(26005)(6512007)(6506007)(53546011)(7416002)(38100700002)(5660300002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFcrNVM2SlJDN2xEQW1ZdWdJV2lIZ3drSEplQ3R4aFk3eW9zd3BMVWtmeWFm?=
 =?utf-8?B?T3FlTXllNEt0Qkg4enNQaytOTm01dTV5U2JrZlhYL2dEbGhIMVVPd3FRSFVY?=
 =?utf-8?B?cXo1WXA5SWNiQVFYcW1tZG84ZjZQbEtvOGNhcGN4ekZTYTNQM0p1ck5BQkpl?=
 =?utf-8?B?SzVuYVhselAyVlBhNTN3SjVTbzRaallGa0ltNUcyMFNHck9GVHdXRTRvcWdY?=
 =?utf-8?B?T3FVSUpBVE9NZnF1S08zZjF4Yzh0dTFCN0lUYmduei9hTEZ6NFREVHRoaXRo?=
 =?utf-8?B?RllzblJQQUF0M3pqdE1hakY5aWdZcmdTY1M1OTk4cWtEMW16TEcvMTNrUWpx?=
 =?utf-8?B?a3o0RGl6Q1MzMHhDVE5nVE55YjJyY1BGSUJYRnljSTQ3SkVKQmJocTRDWDNZ?=
 =?utf-8?B?TEVsVXROUG5OeXFBN3JrbjdISEpSbFFyUTZncWtkaXQxN3RvdDl2ellOcXU1?=
 =?utf-8?B?dlRyUUlMb3NuQk9vdlpYbkptVUtkK09RakVubDZtZlFhaXc4TTdGcWFRMVdF?=
 =?utf-8?B?SHM5OGFwMXF4aGdhZHRRVWNjdkFqbHo4STVqd05oUGlDZnFtVjhRaEVYWWsw?=
 =?utf-8?B?OFdOc21YdFVHSExRZHo0UnRzRm1vUUxaMm1maXFxek1hWWZuN2RISGhvYkFp?=
 =?utf-8?B?T0JCWldrMnFXZ3pRZitYNWNsTlg4YmxJTzJNcERISnBYZjVzbHhXYStFVE5U?=
 =?utf-8?B?TmRsNS82Y2RsbTBxalZnalhPUTJiWGVzaHFWQ3MxV3BSQURQbDZOaWxxdzBL?=
 =?utf-8?B?ajN1TGozT1grY0h6Q3dLSWptQndrbitncHl6TndBTFk3UUtScUdjVkRxM0ly?=
 =?utf-8?B?am5nTG9ia2dZVkFHTTFkc2V2SHlNMkFDbzUrOWpqc0pRc0JHVlhsemtrZGZ5?=
 =?utf-8?B?bmJEaGE4UjBZNm1LM3JwdGNoK1o2eGxNSjkwTitnYkhFcXBEQTdsY2QxYm5I?=
 =?utf-8?B?QVo4SS9OOEd6OVBNVHcwREVReDc1ZU9QVWFOS1lkeUV3QURxaWJxenVFcng2?=
 =?utf-8?B?YXo1d3JRalM2bnhpUXJpUHBvUk9QdWZ0dDR3SXl5VWRIeC9lbjBTTi9pcTBr?=
 =?utf-8?B?UTB2cDBhZjY1MXVkZm1JUTgrSTNvNUpoNk91ZTdZT0VUVTRaQ01VVVRkMmhu?=
 =?utf-8?B?UnhGUTVMNWV2cmhKeStKMjhpeGZwQklXTGJkS3dUVTI5eWxaNVVZdzlaa3Y4?=
 =?utf-8?B?TmIwWlNWOXN3T2JXdnFqN2hwTHlLVzVFN05KVm1OcStJUjlVUzdpdGlZbFVO?=
 =?utf-8?B?a3RQei9vVU1EMDJKVXk5Zk1JaXNqZ1MxeTkxN0tJSXJMY1R2TndOMUVnVXpP?=
 =?utf-8?B?ZXFlUnIvcE9yVUhLNDNZQ3MzdExKK3NoWnF6WjFia1l4S1BlVDhJaUxsaHpH?=
 =?utf-8?B?Rm1ZcjYvQnh2aDZQS3ZCdG1Bd2FQRllRVWs3OExxVHN3b240N09XK2RFQzBu?=
 =?utf-8?B?SHlzOFNwQ2d1WEM3TTBtTk5GQUdUbnFjMWNtRm5UaXczclgwMENscmpJbnpx?=
 =?utf-8?B?TXFVRmhmdnFsRzBHMzZkMitYNTBHN2thUHdwUGdPankwd0dkMGc0Q3pPMG5Y?=
 =?utf-8?B?V0s3SlUxYUl6Nkl5Rm1yaC9ZZXpUY05kcXY5enlkWUwzeC9MdUhNaXI1UXpP?=
 =?utf-8?B?dFRYUkdMVmxFM3pnOXdKMU4yL1A5VElIMFQzdGh3ZVFxTXcva216NEp6VXd4?=
 =?utf-8?B?eEMxQ2N3V21SeTNOSXBaLy92MUI1cXhKZWExUnlLKytmcjZCdG9FZldGd0sv?=
 =?utf-8?B?cHFybmVjSDJKNGZMSVdUSTJ5MTZRdGNQSnRNMWs1ME4wL0d5RWc5a2R2Rzg2?=
 =?utf-8?B?bGYrTlNVRjhKdFgzNEgxMGozc0hwNUg2OFNmSE5LN216UVc2SDRORDQybERU?=
 =?utf-8?B?b3Zvd0FGa0kwQVA3dTZ1ekZ4WXk2V09SSHczUThmUVZwc3Jwc0xsL0JINHZN?=
 =?utf-8?B?ZnNBbG95R2YvZFNnL2ZoOHUrZjRwRjIzMk9PdlB3aU95WmZaei92MXh6Ylpk?=
 =?utf-8?B?Y1VsUnVnV2UrOHdoNFowYkd1SldpYmRkSTZ6bnJyT2FKaklMWkJqcFYxT2J6?=
 =?utf-8?B?a1N0b3RpdTNUajdxem5SSWJVQm9QVUFqK09senE5b1BOVXRieGw2N3MvQlBv?=
 =?utf-8?B?dUxvbHpqYzU5UHM1RXJYWFZEOERoMUhOOVp5alB6WjFFbXFiQmhkWXFZL1hD?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZGFJNWNPVFd6Y0FDVmlZdUlSRU1ncGlFZ0YyMmxsU2QrQTNCVUlwQ25vQWVp?=
 =?utf-8?B?SHpBUGpwR01uQy9QMFEwSCthdXI3UEZ5cnhxZEtBQTYyclhFaHZleU82ZG1w?=
 =?utf-8?B?TlEwUVhqMW4ydzRXYXlSTmxTSUJLQVBWeElaR0RYc2l2OEQ4WlZMS0NicW9F?=
 =?utf-8?B?U0Q5Ri9ndDBTU1diVUlwOGtCVThWck9RR2pkdGZUc3hJUGRRTUVoNnRTcTJl?=
 =?utf-8?B?emRMTFBOUkMxWDh0OUVjbE1jTmNLUFpMbVVtaE1Oc3kyTmFqN0k3ZFBKVDFX?=
 =?utf-8?B?M09WQmtwekFQWnowUHV4MXNlRXhadlJ2TVlPOTZBVk53VWxxYTQvZ0dZL2J5?=
 =?utf-8?B?SHNCZkpUTU9Qc2Rac3F4bTRsM3FvODE0Q1MxalVjV2pXSjdKZmRmOEpFcjRW?=
 =?utf-8?B?VzlPSWh4STh6L2lGaGMwaFdKWlJQTW90R28yZmdJNFFMVWlBbGhTM3JLRkFV?=
 =?utf-8?B?dEx2dXpsVU9ZQjFLUVp2Q3hRUy93NnNrcDZ0MEtSVDVEUHVRUzFoYXlBN1Jp?=
 =?utf-8?B?MDJMcVBpdUNxeUZCMU1jdUtBK0hIWE5YOVpKMTFCQ1ZqcjZTVGJSMjIyRU00?=
 =?utf-8?B?SFp4TzVPRDl3eTdsTUlWc2hTa1NKTTZ0bWhZQnkzT2Z2L29VWXV1SGRid1lL?=
 =?utf-8?B?ejhkRDBoOHBrQmczemg3S3ExQlZmOTVMNWNHSmNSTmlXTFppYmEyeTlZK01m?=
 =?utf-8?B?TlhwRGZlMnhUL0RobFR5blRnYmNLdnRTZHN0T3JFUkdKQlVGdC9LM0tXNWh3?=
 =?utf-8?B?dEU2S0JUWjJFK2RuZTBnWnZSci9kamJPdS9lUUhiZU1nTytrR1ZFWkoyWjQw?=
 =?utf-8?B?TmE2MDNtY3M5NFRxSC9iU2RtT2pHMm0vZXZaYVBMUVNqQ1Y5TitUejVwZktM?=
 =?utf-8?B?dVc1WUhhRENWc25HOVl6UDJPcUFpMjF6blRPZkZDaXhTQWZKcWlRSEM4WW1G?=
 =?utf-8?B?ME9BbC91b3dKa2ZNSWNvUzc5L0hVMkg4U1RpZEVSTFd6Skt2a0hOcFZ1VlEr?=
 =?utf-8?B?dm9sdFRLZzFMeVBCLzRXcGZyRU44bGd4WEFMRUhldE5uajdzM3dsSU45UWsv?=
 =?utf-8?B?UGFWVktxb29ZYjNneTB4NHFvTFZkQXZiZkJFMkN2QURCT2N3ZmN5alZJeXFP?=
 =?utf-8?B?VGNLZWV2WFR3UERrRlJyZUUyUm9aTk81akd6T01nWEJ0Q3FBaUFPSkJLeWNF?=
 =?utf-8?B?QS9jMjF3S1RtSVFUWjNRbmNBYnJWeGhVTkhJck96bkJxWjVVK1RnVVFKbzVa?=
 =?utf-8?B?Ums5MU9IeVFLYjBVZzdrbVoyeE41MjBJazlVeUdJcWVRU3l4OHc4QmRUWmY3?=
 =?utf-8?B?Q280OEtEMW92OHZ5VlVHbGZFdVpUWHloVGMwK0hIYXFlYXIxVTJ0SWNFNCtm?=
 =?utf-8?B?dDlEY2pLdk5Ed251WE52cHNnN1Bxck1scE8xdWRDQkQ4RGdrNUZzQndMa0tk?=
 =?utf-8?B?ai9ZZHNDeXJOSGxKU2NEb3NRdnoyWWVZcmxmZlB3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb353521-7221-4ace-863a-08db6e94f7b2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 18:10:29.4944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GPQl93zMPKQolHtjeZo9wQzuxn/XjxSptjw52Gya1BEJPxY1a5TJOuH9OAPzyHAiqKhHQ9AAfJ8S8IwPpejxQTNPQERzbT01BRuitlrSCXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-16_12,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306160164
X-Proofpoint-ORIG-GUID: g96QMsqK-9jPIxBz6lyZb0_1Y7wt02XN
X-Proofpoint-GUID: g96QMsqK-9jPIxBz6lyZb0_1Y7wt02XN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/2023 17:46, Shameerali Kolothum Thodi wrote:
> Hi Joao,
> 
>> -----Original Message-----
>> From: Joao Martins [mailto:joao.m.martins@oracle.com]
>> Sent: 18 May 2023 21:47
>> To: iommu@lists.linux.dev
>> Cc: Jason Gunthorpe <jgg@nvidia.com>; Kevin Tian <kevin.tian@intel.com>;
>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>; Lu
>> Baolu <baolu.lu@linux.intel.com>; Yi Liu <yi.l.liu@intel.com>; Yi Y Sun
>> <yi.y.sun@intel.com>; Eric Auger <eric.auger@redhat.com>; Nicolin Chen
>> <nicolinc@nvidia.com>; Joerg Roedel <joro@8bytes.org>; Jean-Philippe
>> Brucker <jean-philippe@linaro.org>; Suravee Suthikulpanit
>> <suravee.suthikulpanit@amd.com>; Will Deacon <will@kernel.org>; Robin
>> Murphy <robin.murphy@arm.com>; Alex Williamson
>> <alex.williamson@redhat.com>; kvm@vger.kernel.org; Joao Martins
>> <joao.m.martins@oracle.com>
>> Subject: [PATCH RFCv2 22/24] iommu/arm-smmu-v3: Add
>> read_and_clear_dirty() support
>>
>> From: Keqian Zhu <zhukeqian1@huawei.com>
>>
>> .read_and_clear_dirty() IOMMU domain op takes care of reading the dirty
>> bits (i.e. PTE has both DBM and AP[2] set) and marshalling into a bitmap of
>> a given page size.
>>
>> While reading the dirty bits we also clear the PTE AP[2] bit to mark it as
>> writable-clean depending on read_and_clear_dirty() flags.
>>
>> Structure it in a way that the IOPTE walker is generic, and so we pass a
>> function pointer over what to do on a per-PTE basis.
>>
>> [Link below points to the original version that was based on]
>>
>> Link:
>> https://lore.kernel.org/lkml/20210413085457.25400-11-zhukeqian1@huaw
>> ei.com/
>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Co-developed-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> [joaomart: Massage commit message]
>> Co-developed-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  23 +++++
>>  drivers/iommu/io-pgtable-arm.c              | 104
>> ++++++++++++++++++++
>>  2 files changed, 127 insertions(+)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index e2b98a6a6b74..2cde14003469 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -2765,6 +2765,28 @@ static int arm_smmu_enable_nesting(struct
>> iommu_domain *domain)
>>  	return ret;
>>  }
>>
>> +static int arm_smmu_read_and_clear_dirty(struct iommu_domain
>> *domain,
>> +					 unsigned long iova, size_t size,
>> +					 unsigned long flags,
>> +					 struct iommu_dirty_bitmap *dirty)
>> +{
>> +	struct arm_smmu_domain *smmu_domain =
>> to_smmu_domain(domain);
>> +	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
>> +	int ret;
>> +
>> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
>> +		return -EINVAL;
>> +
>> +	if (!ops || !ops->read_and_clear_dirty) {
>> +		pr_err_once("io-pgtable don't support dirty tracking\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	ret = ops->read_and_clear_dirty(ops, iova, size, flags, dirty);
>> +
>> +	return ret;
>> +}
>> +
>>  static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args
>> *args)
>>  {
>>  	return iommu_fwspec_add_ids(dev, args->args, 1);
>> @@ -2893,6 +2915,7 @@ static struct iommu_ops arm_smmu_ops = {
>>  		.iova_to_phys		= arm_smmu_iova_to_phys,
>>  		.enable_nesting		= arm_smmu_enable_nesting,
>>  		.free			= arm_smmu_domain_free,
>> +		.read_and_clear_dirty	= arm_smmu_read_and_clear_dirty,
>>  	}
>>  };
>>
>> diff --git a/drivers/iommu/io-pgtable-arm.c
>> b/drivers/iommu/io-pgtable-arm.c
>> index b2f470529459..de9e61f8452d 100644
>> --- a/drivers/iommu/io-pgtable-arm.c
>> +++ b/drivers/iommu/io-pgtable-arm.c
>> @@ -717,6 +717,109 @@ static phys_addr_t arm_lpae_iova_to_phys(struct
>> io_pgtable_ops *ops,
>>  	return iopte_to_paddr(pte, data) | iova;
>>  }
>>
>> +struct arm_lpae_iopte_read_dirty {
>> +	unsigned long flags;
>> +	struct iommu_dirty_bitmap *dirty;
>> +};
>> +
>> +static int __arm_lpae_read_and_clear_dirty(unsigned long iova, size_t size,
>> +					   arm_lpae_iopte *ptep, void *opaque)
>> +{
>> +	struct arm_lpae_iopte_read_dirty *arg = opaque;
>> +	struct iommu_dirty_bitmap *dirty = arg->dirty;
>> +	arm_lpae_iopte pte;
>> +
>> +	pte = READ_ONCE(*ptep);
>> +	if (WARN_ON(!pte))
>> +		return -EINVAL;
>> +
>> +	if ((pte & ARM_LPAE_PTE_AP_WRITABLE) ==
>> ARM_LPAE_PTE_AP_WRITABLE)
>> +		return 0;
>> +
>> +	iommu_dirty_bitmap_record(dirty, iova, size);
>> +	if (!(arg->flags & IOMMU_DIRTY_NO_CLEAR))
>> +		set_bit(ARM_LPAE_PTE_AP_RDONLY_BIT, (unsigned long *)ptep);
>> +	return 0;
>> +}
>> +
>> +static int __arm_lpae_iopte_walk(struct arm_lpae_io_pgtable *data,
>> +				 unsigned long iova, size_t size,
>> +				 int lvl, arm_lpae_iopte *ptep,
>> +				 int (*fn)(unsigned long iova, size_t size,
>> +					   arm_lpae_iopte *pte, void *opaque),
>> +				 void *opaque)
>> +{
>> +	arm_lpae_iopte pte;
>> +	struct io_pgtable *iop = &data->iop;
>> +	size_t base, next_size;
>> +	int ret;
>> +
>> +	if (WARN_ON_ONCE(!fn))
>> +		return -EINVAL;
>> +
>> +	if (WARN_ON(lvl == ARM_LPAE_MAX_LEVELS))
>> +		return -EINVAL;
>> +
>> +	ptep += ARM_LPAE_LVL_IDX(iova, lvl, data);
>> +	pte = READ_ONCE(*ptep);
>> +	if (WARN_ON(!pte))
>> +		return -EINVAL;
>> +
>> +	if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
>> +		if (iopte_leaf(pte, lvl, iop->fmt))
>> +			return fn(iova, size, ptep, opaque);
>> +
>> +		/* Current level is table, traverse next level */
>> +		next_size = ARM_LPAE_BLOCK_SIZE(lvl + 1, data);
>> +		ptep = iopte_deref(pte, data);
>> +		for (base = 0; base < size; base += next_size) {
>> +			ret = __arm_lpae_iopte_walk(data, iova + base,
>> +						    next_size, lvl + 1, ptep,
>> +						    fn, opaque);
>> +			if (ret)
>> +				return ret;
>> +		}
>> +		return 0;
>> +	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
>> +		return fn(iova, size, ptep, opaque);
>> +	}
>> +
>> +	/* Keep on walkin */
>> +	ptep = iopte_deref(pte, data);
>> +	return __arm_lpae_iopte_walk(data, iova, size, lvl + 1, ptep,
>> +				     fn, opaque);
>> +}
>> +
>> +static int arm_lpae_read_and_clear_dirty(struct io_pgtable_ops *ops,
>> +					 unsigned long iova, size_t size,
>> +					 unsigned long flags,
>> +					 struct iommu_dirty_bitmap *dirty)
>> +{
>> +	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
>> +	struct io_pgtable_cfg *cfg = &data->iop.cfg;
>> +	struct arm_lpae_iopte_read_dirty arg = {
>> +		.flags = flags, .dirty = dirty,
>> +	};
>> +	arm_lpae_iopte *ptep = data->pgd;
>> +	int lvl = data->start_level;
>> +	long iaext = (s64)iova >> cfg->ias;
>> +
>> +	if (WARN_ON(!size || (size & cfg->pgsize_bitmap) != size))
>> +		return -EINVAL;
> 
> I guess the size here is supposed to be one of the pgsize that iommu supports.
> But looking at the code, it looks like we are passing the iova mapped length and
> it fails here in my test setup. Could you please check and confirm.
> 
I think this might be from the original patch, and it's meant to test that
length is aligned to the page size, but I failed to removed it this snip. We
should remove this.

> Thanks,
> Shameer
> 
> 
>> +
>> +	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
>> +		iaext = ~iaext;
>> +	if (WARN_ON(iaext))
>> +		return -EINVAL;
>> +
>> +	if (data->iop.fmt != ARM_64_LPAE_S1 &&
>> +	    data->iop.fmt != ARM_32_LPAE_S1)
>> +		return -EINVAL;
>> +
>> +	return __arm_lpae_iopte_walk(data, iova, size, lvl, ptep,
>> +				     __arm_lpae_read_and_clear_dirty, &arg);
>> +}
>> +
>>  static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
>>  {
>>  	unsigned long granule, page_sizes;
>> @@ -795,6 +898,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
>>  		.map_pages	= arm_lpae_map_pages,
>>  		.unmap_pages	= arm_lpae_unmap_pages,
>>  		.iova_to_phys	= arm_lpae_iova_to_phys,
>> +		.read_and_clear_dirty = arm_lpae_read_and_clear_dirty,
>>  	};
>>
>>  	return data;
>> --
>> 2.17.2
> 
