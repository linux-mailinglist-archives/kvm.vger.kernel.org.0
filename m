Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C393B51BEBE
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 14:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359369AbiEEMFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 08:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356598AbiEEMFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 08:05:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081072AC7F;
        Thu,  5 May 2022 05:02:11 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245BMocf027199;
        Thu, 5 May 2022 12:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=bGhF49dJcdnowlurpF2GARz1/RvjovKAcYVA6sREx8I=;
 b=hLrXU31eC83oQ9DASyzXDZKzjsiQxJl+ExJNcw+bxpvZeYAxSIkrZr4aEi824cdCDOJp
 7emRvIEaSB3FqzrQVcyiQz/QYQeGpXULVZbV4a9HjifVTOPgRSFlO2mzil5kNRm36yX6
 j7hGAeKxpRDdfsRwmjNVn9zzUieZKMK5ewhP3XLRX9PX7/7cqmgv9hcNtq7bE5EQBSHE
 nzqt/CM/Zg4WzXZlFOwIgxsiTIn1D7Kr2yxjs+SecSFanH10wAW9EhtGx33WYrHTU9mN
 9Jst7ItAV+/pGjGB0WAZty4UwZwpiyFHxrrIJBd3eSAxyu2KUtvTYFzZwLO0TiW0XsYL Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvdngrq5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:02:11 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 245Bk2lL028206;
        Thu, 5 May 2022 12:02:10 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvdngrq55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:02:10 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245BwL83009625;
        Thu, 5 May 2022 12:02:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3fscdk54rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:02:08 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245Bmh4V38994268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 11:48:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 678094203F;
        Thu,  5 May 2022 12:02:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D1CE42045;
        Thu,  5 May 2022 12:02:05 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.61.5])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 12:02:05 +0000 (GMT)
Message-ID: <2a27308d38150336ad906cfee2adc7481442f1b0.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: migration: don't run tests
 when facilities are not there
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Date:   Thu, 05 May 2022 14:02:04 +0200
In-Reply-To: <20220505135439.33abf440@p-imbrenda>
References: <20220505102705.3621584-1-nrb@linux.ibm.com>
         <20220505135439.33abf440@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Vktj-wOEmSuR9beREjmRW8bJbUetGN1O
X-Proofpoint-ORIG-GUID: rxEmMe1UYK2YVDNjpv8cXpWK9-mZaM51
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_04,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 adultscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0 spamscore=0
 mlxlogscore=843 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-05 at 13:54 +0200, Claudio Imbrenda wrote:
> I think this patch should actually be folded in the previous one,
> I'll
> do that unless there are objections

Thanks. Fine for me.
