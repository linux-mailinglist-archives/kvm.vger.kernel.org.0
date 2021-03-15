Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9E433AFD9
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 11:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhCOKSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 06:18:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12192 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230021AbhCOKSR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 06:18:17 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12FA4VQX030588
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 06:18:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Z/Kb7g3WBoZpHwVf0hsdUU64/e0tOzoxg2AFuVaqHU4=;
 b=nXMoP+7C6Xc0nuSso8HLR94GobeAVoSOSsh6W4nSW079nN4I15nSg6yL0xXumMgOwzpH
 jyD0s4eCXnxb55SOY96aQ80M9Dgdtm1EUiI3JrtAOrv/k/Hs46FHoRBcPrH78TVKR6vr
 iOecRyqbNWIICo/IgfkU7MRSNT8UMEGJ+imXAqKiIiCFoJpWUSNhcR70/50tzxD3ZOw9
 e/nRJLrAOXrCCstl5srOMZVuxh3HXLDrI2/gyr1fMVWl0QQwW7vurRMIXEn6JL0zMNxn
 IuSQWI7q+0EWtnDWLIXuFTFlJqm0iOxdY390yHulGC2tdu3EAXfgtZ3Y81x5DAS9DILl Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 379yhv15aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 06:18:16 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12FA4btK031370
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 06:18:15 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 379yhv1597-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 06:18:15 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12FA99S7016801;
        Mon, 15 Mar 2021 10:18:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 378mnh8w9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 10:18:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12FAI9rN34144684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Mar 2021 10:18:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63585A4065;
        Mon, 15 Mar 2021 10:18:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 037C4A4051;
        Mon, 15 Mar 2021 10:18:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.14.133])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Mar 2021 10:18:08 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: mvpg: add checks for
 op_acc_id
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        pmorel@linux.ibm.com
References: <20210312124700.142269-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <6e9022f6-de6f-d3c5-b30f-5935fb6e4ca4@linux.ibm.com>
Date:   Mon, 15 Mar 2021 11:18:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210312124700.142269-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_03:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103150067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/12/21 1:47 PM, Claudio Imbrenda wrote:
> + * Check that the Operand Access Identification matches with the values of

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Thanks, picked!
